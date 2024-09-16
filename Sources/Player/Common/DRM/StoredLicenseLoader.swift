import AVFoundation
import Foundation

// MARK: - StoredLicenseLoader

final class StoredLicenseLoader: NSObject, LicenseLoader {
	private let license: Data

	init?(localLicenseUrl: URL) {
		guard let license = try? Data(contentsOf: localLicenseUrl) else {
			return nil
		}
		self.license = license
	}

	func getLicense() async throws -> Data {
		license
	}
}

// MARK: AVContentKeySessionDelegate

extension StoredLicenseLoader: AVContentKeySessionDelegate {
	func contentKeySession(
		_ session: AVContentKeySession,
		didProvide keyRequest: AVContentKeyRequest
	) {
		do {
			#if os(iOS)
				try keyRequest.respondByRequestingPersistableContentKeyRequestAndReturnError()
			#else
				try keyRequest.respondByRequestingPersistableContentKeyRequest()
			#endif
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.licenseLoaderContentKeyRequestFailed(error: error))
			keyRequest.processContentKeyResponseError(error)
		}
	}

	func contentKeySession(
		_ session: AVContentKeySession,
		didProvide keyRequest: AVPersistableContentKeyRequest
	) {
		SafeTask {
			do {
				let license = try await getLicense()
				keyRequest.processContentKeyResponse(AVContentKeyResponse(fairPlayStreamingKeyResponseData: license))
			} catch {
				PlayerWorld.logger?.log(loggable: PlayerLoggable.licenseLoaderProcessContentKeyResponseFailed(error: error))
				keyRequest.processContentKeyResponseError(error)
			}
		}
	}
}
