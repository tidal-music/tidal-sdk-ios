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
}

private extension FairPlayLicenseFetcher {
	func createSpc(keyRequest: KeyRequest) async throws -> Data {
		let keyId = try keyRequest.getKeyId()
		let certificate = try await getCertificate()
		return try await keyRequest.createServerPlaybackContext(for: keyId, using: certificate)
	}

	func getCertificate() async throws -> Data {
		if let certificate {
			return certificate
		}

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
			PlayerWorld.logger?.log(loggable: PlayerLoggable.getPlaybackInfo(error: error))
			
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
