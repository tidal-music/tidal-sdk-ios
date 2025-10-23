import Auth
import AVFoundation
import Foundation

// MARK: - FairPlayLicenseFetcherError

private enum FairPlayLicenseFetcherError: Int {
	case unableToRenewAccessToken = 0
	case emptyLicensePayload

	func error() -> Error {
		PlayerInternalError(
			errorId: .PERetryable,
			errorType: .drmLicenseError,
			code: rawValue
		)
	}
}

// MARK: - FairPlayLicenseFetcher

final class FairPlayLicenseFetcher {
	private static let CERTIFICATE_URL = URL(string: "https://fp.fa.tidal.com/certificate")!
	private static let LICENSE_URL = URL(string: "https://fp.fa.tidal.com/license")!

	private let httpClient: HttpClient
	private let credentialsProvider: CredentialsProvider
	private let playerEventSender: PlayerEventSender
	private let featureFlagProvider: FeatureFlagProvider
	private var certificate: Data?

	init(
		with httpClient: HttpClient,
		credentialsProvider: CredentialsProvider,
		and playerEventSender: PlayerEventSender,
		featureFlagProvider: FeatureFlagProvider
	) {
		self.httpClient = httpClient
		self.credentialsProvider = credentialsProvider
		self.playerEventSender = playerEventSender
		self.featureFlagProvider = featureFlagProvider

		SafeTask {
			_ = try? await self.getCertificate()
		}
	}

	func getLicense(streamingSessionId: String, keyRequest: KeyRequest) async throws -> Data {
		let spc = try await createSpc(keyRequest: keyRequest)
		let license = try await getLicense(streamingSessionId: streamingSessionId, licenseChallenge: spc)

		if let persistableContentKeyRequest = keyRequest as? AVPersistableContentKeyRequest {
			return try persistableContentKeyRequest.persistableContentKey(fromKeyVendorResponse: license)
		} else {
			return license
		}
	}
	
	// Public method to access certificate for external callers (only available with improved DRM handling)
	func preloadCertificate() async throws {
		guard featureFlagProvider.shouldUseImprovedDRMHandling() else {
			// No-op when not using improved DRM handling
			return
		}
		_ = try await getCertificate()
	}
}

private extension FairPlayLicenseFetcher {
	func createSpc(keyRequest: KeyRequest) async throws -> Data {
		let keyId = try keyRequest.getKeyId()
		let certificate = try await getCertificate()
		return try await keyRequest.createServerPlaybackContext(for: keyId, using: certificate)
	}

	func getCertificate() async throws -> Data {
		if let certificate = certificate {
			return certificate
		}

		if featureFlagProvider.shouldUseImprovedDRMHandling() {
			return try await getCertificateWithRetry()
		} else {
			return try await getCertificateLegacy()
		}
	}
	
	private func getCertificateWithRetry() async throws -> Data {
		let maxRetries = 3
		var lastError: Error?
		
		for attempt in 1...maxRetries {
			do {
				let certificate = try await httpClient.get(
					url: FairPlayLicenseFetcher.CERTIFICATE_URL, 
					headers: [:]
				)
				self.certificate = certificate
				return certificate
			} catch {
				lastError = error
				if attempt < maxRetries {
					// Exponential backoff: 1s, 2s, 4s
					let delay = UInt64(attempt * 1_000_000_000)
					try await Task.sleep(nanoseconds: delay)
				}
			}
		}
		
		throw lastError ?? PlayerInternalError(
			errorId: .PERetryable,
			errorType: .drmLicenseError,
			code: -3,
			description: "Certificate fetch failed after \(maxRetries) attempts"
		)
	}
	
	private func getCertificateLegacy() async throws -> Data {
		let certificate = try await httpClient.get(url: FairPlayLicenseFetcher.CERTIFICATE_URL, headers: [:])
		self.certificate = certificate
		return certificate
	}

	func getLicense(
		streamingSessionId: String,
		licenseChallenge: Data
	) async throws -> Data {
		let start = PlayerWorld.timeProvider.timestamp()

		do {
			var license: Data?

			// Use improved DRM handling with retry logic when feature flag is enabled
			if featureFlagProvider.shouldUseImprovedDRMHandling() {
				license = try await getLicenseWithRetry(
					streamingSessionId: streamingSessionId,
					licenseChallenge: licenseChallenge
				)
			} else {
				let token = try await credentialsProvider.getAuthBearerToken()
				license = try await httpClient.post(
					url: FairPlayLicenseFetcher.LICENSE_URL,
					headers: [
						"Authorization": token,
						"Content-Type": "application/octet-stream",
						"X-Tidal-Streaming-Session-Id": streamingSessionId,
					],
					payload: licenseChallenge
				)
			}

			guard let license else {
				throw FairPlayLicenseFetcherError.emptyLicensePayload.error()
			}

			let endTimestamp = PlayerWorld.timeProvider.timestamp()
			playerEventSender.send(DrmLicenseFetch(
				streamingSessionId: streamingSessionId,
				startTimestamp: start,
				endTimestamp: endTimestamp,
				endReason: .COMPLETE,
				errorMessage: nil,
				errorCode: nil
			))

			return license

		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.getLicenseFailed(error: error))

			// TODO: Should we update this to handle proper conversion from TidalError, otherwise they will always be EUnexpected
			let playerError = PlayerInternalError.from(error)

			let endTimestamp = PlayerWorld.timeProvider.timestamp()
			playerEventSender.send(DrmLicenseFetch(
				streamingSessionId: streamingSessionId,
				startTimestamp: start,
				endTimestamp: endTimestamp,
				endReason: error is CancellationError ? .OTHER : .ERROR,
				errorMessage: playerError.technicalDescription,
				errorCode: playerError.code
			))

			throw error
		}
	}

	/// Fetches DRM license with retry logic for auth token refresh and transient errors
	private func getLicenseWithRetry(
		streamingSessionId: String,
		licenseChallenge: Data
	) async throws -> Data? {
		let maxRetries = 3
		var lastError: Error?
		var authTokenRefreshed = false

		for attempt in 1...maxRetries {
			do {
				let token = try await credentialsProvider.getAuthBearerToken()

				let license = try await httpClient.post(
					url: FairPlayLicenseFetcher.LICENSE_URL,
					headers: [
						"Authorization": token,
						"Content-Type": "application/octet-stream",
						"X-Tidal-Streaming-Session-Id": streamingSessionId,
					],
					payload: licenseChallenge
				)

				return license

			} catch let error as HttpError {
				lastError = error

				switch error {
				case .httpClientError(let statusCode, _):
					// Handle 401 Unauthorized - try refreshing token once
					if statusCode == 401 && !authTokenRefreshed {
						// Force token refresh by requesting credentials with the invalid token sub-status
						do {
							_ = try await credentialsProvider.getCredentials(
								apiErrorSubStatus: ApiErrorSubStatus.invalidAccessToken.rawValue
							)
							authTokenRefreshed = true

							// Retry immediately after token refresh
							if attempt < maxRetries {
								try await Task.sleep(nanoseconds: 500_000_000) // 0.5s delay
								continue
							}
						} catch {
							PlayerWorld.logger?.log(loggable: PlayerLoggable.getAuthBearerTokenCredentialFailed(error: error))
							throw error
						}
					}

					// Handle 429 Rate Limit - retry with backoff
					if statusCode == 429 && attempt < maxRetries {
						let delay = UInt64(attempt * 2_000_000_000) // 2s, 4s, 6s
						try await Task.sleep(nanoseconds: delay)
						continue
					}

					// Other 4xx errors should not be retried
					throw error

				case .httpServerError:
					// Retry 5xx server errors with exponential backoff
					if attempt < maxRetries {
						let delay = UInt64(attempt * 1_000_000_000) // 1s, 2s, 3s
						try await Task.sleep(nanoseconds: delay)
						continue
					}
					throw error
				}

			} catch {
				lastError = error

				// Check if this is a retryable network/timeout error
				if isRetryableDRMError(error) && attempt < maxRetries {
					let delay = UInt64(attempt * 1_000_000_000) // 1s, 2s, 3s
					try await Task.sleep(nanoseconds: delay)
					continue
				}

				// Non-retryable error or max retries reached
				throw error
			}
		}

		throw lastError ?? PlayerInternalError(
			errorId: .PERetryable,
			errorType: .drmLicenseError,
			code: -4,
			description: "License fetch failed after \(maxRetries) attempts"
		)
	}

	/// Determines if an error is retryable for DRM license fetching
	private func isRetryableDRMError(_ error: Error) -> Bool {
		// Check PlayerInternalError types
		if let playerError = error as? PlayerInternalError {
			switch playerError.errorType {
			case .networkError, .timeOutError:
				return true
			case .drmLicenseError:
				// Retry specific DRM error codes
				return true
			default:
				return false
			}
		}

		// Check URLError types
		if let urlError = error as? URLError {
			switch urlError.code {
			case .timedOut, .networkConnectionLost, .notConnectedToInternet,
				 .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
				return true
			default:
				return false
			}
		}

		return false
	}
}
