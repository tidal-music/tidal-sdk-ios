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
		// Never block this method - it's called on AVFoundation's internal queue
		Task {
			await handlePersistableKeyRequest(keyRequest)
		}
	}
	
	func contentKeySession(_ session: AVContentKeySession, contentKeyRequest keyRequest: AVContentKeyRequest, didFailWithError error: Error) {
		PlayerWorld.logger?.log(loggable: PlayerLoggable.licenseLoaderProcessContentKeyResponseFailed(error: error))
	}
	
	private func handlePersistableKeyRequest(_ keyRequest: AVPersistableContentKeyRequest) async {
		do {
			// Check if task was cancelled before processing
			try Task.checkCancellation()
			
			let license = try await getLicense()
			let response = AVContentKeyResponse(fairPlayStreamingKeyResponseData: license)
			keyRequest.processContentKeyResponse(response)
			
		} catch is CancellationError {
			// Don't call processContentKeyResponseError for cancellation
			return
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.licenseLoaderProcessContentKeyResponseFailed(error: error))
			keyRequest.processContentKeyResponseError(error)
		}
	}
}
