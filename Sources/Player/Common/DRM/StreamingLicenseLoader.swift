import AVFoundation
import Foundation

// MARK: - StreamingLicenseLoader

final class StreamingLicenseLoader: NSObject, LicenseLoader {
	private let fairPlayLicenseFetcher: FairPlayLicenseFetcher
	let streamingSessionId: String

	private var pendingKeyRequest: AVContentKeyRequest?

	init(fairPlayLicenseFetcher: FairPlayLicenseFetcher, streamingSessionId: String) {
		self.fairPlayLicenseFetcher = fairPlayLicenseFetcher
		self.streamingSessionId = streamingSessionId
	}

	func getLicense() async throws -> Data {
		guard let pendingKeyRequest else {
			throw LicenseLoaderError.missingLicense
		}

		return try await fairPlayLicenseFetcher.getLicense(
			streamingSessionId: streamingSessionId,
			keyRequest: pendingKeyRequest
		)
	}
}

// MARK: AVContentKeySessionDelegate

extension StreamingLicenseLoader: AVContentKeySessionDelegate {
	func contentKeySession(_ session: AVContentKeySession, didProvide keyRequest: AVContentKeyRequest) {
		let semaphore = DispatchSemaphore(value: 0)

		SafeTask {
			defer {
				self.pendingKeyRequest = nil
				semaphore.signal()
			}

			do {
				self.pendingKeyRequest = keyRequest
				let license = try await getLicense()
				keyRequest.processContentKeyResponse(AVContentKeyResponse(fairPlayStreamingKeyResponseData: license))
			} catch {
				keyRequest.processContentKeyResponseError(error)
			}
		}

		semaphore.wait()
	}
}
