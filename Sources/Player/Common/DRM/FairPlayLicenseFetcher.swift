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
		// Add timeout to prevent hanging DRM operations
		return try await withThrowingTaskGroup(of: Data.self) { group in
			// Main license fetch task
			group.addTask {
				let spc = try await self.createSpc(keyRequest: keyRequest)
				let license = try await self.getLicense(streamingSessionId: streamingSessionId, licenseChallenge: spc)

				if let persistableContentKeyRequest = keyRequest as? AVPersistableContentKeyRequest {
					return try persistableContentKeyRequest.persistableContentKey(fromKeyVendorResponse: license)
				} else {
					return license
				}
			}
			
			// Timeout task
			group.addTask {
				try await Task.sleep(nanoseconds: 30_000_000_000) // 30 second timeout
				throw PlayerInternalError(
					errorId: .PERetryable,
					errorType: .drmLicenseError,
					code: -4,
					description: "License fetch timeout after 30 seconds"
				)
			}
			
			// Return the first completed task (either success or timeout)
			guard let result = try await group.next() else {
				throw PlayerInternalError(
					errorId: .EUnexpected,
					errorType: .drmLicenseError,
					code: -5,
					description: "License fetch task group failed unexpectedly"
				)
			}
			
			// Cancel remaining tasks
			group.cancelAll()
			
			return result
		}
	}
	
	// Public method to access certificate for external callers
	func preloadCertificate() async throws {
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

	func getLicense(
		streamingSessionId: String,
		licenseChallenge: Data
	) async throws -> Data {
		let start = PlayerWorld.timeProvider.timestamp()

		do {
			var license: Data?

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
}
