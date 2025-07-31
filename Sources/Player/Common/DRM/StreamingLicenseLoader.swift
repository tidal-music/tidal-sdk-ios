import AVFoundation
import Foundation

// MARK: - StreamingLicenseLoader

final class StreamingLicenseLoader: NSObject, LicenseLoader {
	private let fairPlayLicenseFetcher: FairPlayLicenseFetcher
	let streamingSessionId: String

	private let drmQueue = DispatchQueue(label: "com.tidal.player.drm.streaming", qos: .userInitiated)
	private var pendingKeyRequest: AVContentKeyRequest?
	private var pendingTasks: [AVContentKeyRequest: Task<Void, Never>] = [:]
	private let serialQueue = DispatchQueue(label: "com.tidal.player.drm.streaming.state", qos: .userInitiated)

	init(fairPlayLicenseFetcher: FairPlayLicenseFetcher, streamingSessionId: String) {
		self.fairPlayLicenseFetcher = fairPlayLicenseFetcher
		self.streamingSessionId = streamingSessionId
	}

	func getLicense() async throws -> Data {
		return try await withCheckedThrowingContinuation { continuation in
			serialQueue.async {
				guard let pendingKeyRequest = self.pendingKeyRequest else {
					continuation.resume(throwing: LicenseLoaderError.missingLicense)
					return
				}
				
				Task {
					do {
						let license = try await self.fairPlayLicenseFetcher.getLicense(
							streamingSessionId: self.streamingSessionId,
							keyRequest: pendingKeyRequest
						)
						continuation.resume(returning: license)
					} catch {
						continuation.resume(throwing: error)
					}
				}
			}
		}
	}
	
	private func cleanupTask(for keyRequest: AVContentKeyRequest) {
		serialQueue.async {
			self.pendingTasks.removeValue(forKey: keyRequest)
		}
	}
	
	private func setPendingKeyRequest(_ keyRequest: AVContentKeyRequest?) {
		serialQueue.async {
			self.pendingKeyRequest = keyRequest
		}
	}
}

// MARK: AVContentKeySessionDelegate

extension StreamingLicenseLoader: AVContentKeySessionDelegate {
	func contentKeySession(_ session: AVContentKeySession, didProvide keyRequest: AVContentKeyRequest) {
		// Never block this method - it's called on AVFoundation's internal queue
		let task = Task {
			await handleKeyRequest(keyRequest)
		}
		
		serialQueue.async {
			self.pendingTasks[keyRequest] = task
		}
	}
	
	func contentKeySession(_ session: AVContentKeySession, contentKeyRequest keyRequest: AVContentKeyRequest, didFailWithError error: Error) {
		PlayerWorld.logger?.log(loggable: PlayerLoggable.streamingGetLicenseFailed(error: error))
		cleanupTask(for: keyRequest)
		
		// Check if this is a retryable error
		if shouldRetryDRMError(error) {
			Task {
				await retryKeyRequestAfterDelay(keyRequest, session: session)
			}
		}
	}
	
	private func handleKeyRequest(_ keyRequest: AVContentKeyRequest) async {
		defer {
			cleanupTask(for: keyRequest)
		}
		
		do {
			setPendingKeyRequest(keyRequest)
			
			let license = try await fairPlayLicenseFetcher.getLicense(
				streamingSessionId: streamingSessionId,
				keyRequest: keyRequest
			)
			
			// Check if task was cancelled before processing response
			try Task.checkCancellation()
			
			let response = AVContentKeyResponse(fairPlayStreamingKeyResponseData: license)
			keyRequest.processContentKeyResponse(response)
			
			setPendingKeyRequest(nil)
			
		} catch is CancellationError {
			// Don't call processContentKeyResponseError for cancellation
			setPendingKeyRequest(nil)
			return
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.streamingGetLicenseFailed(error: error))
			
			setPendingKeyRequest(nil)
			keyRequest.processContentKeyResponseError(error)
		}
	}
	
	private func shouldRetryDRMError(_ error: Error) -> Bool {
		let nsError = error as NSError
		
		// Retry on specific transient DRM errors
		switch nsError.code {
		case -11800 where nsError.domain == AVFoundationErrorDomain:
			// DRM operation failed - could be temporary network issue
			return true
		case let code where nsError.domain == NSURLErrorDomain && 
			[NSURLErrorTimedOut, NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet].contains(code):
			// Network-related errors are retryable
			return true
		default:
			return false
		}
	}
	
	private func retryKeyRequestAfterDelay(_ keyRequest: AVContentKeyRequest, session: AVContentKeySession) async {
		do {
			// Exponential backoff - wait 2 seconds before retry
			try await Task.sleep(nanoseconds: 2_000_000_000)
			
			// Retry by requesting the key again
			session.renewExpiringResponseData(for: keyRequest)
		} catch {
			// If delay was cancelled, don't retry
			keyRequest.processContentKeyResponseError(error)
		}
	}
}
