import AVFoundation
import Foundation

// MARK: - StreamingLicenseLoader

final class StreamingLicenseLoader: NSObject, LicenseLoader {
	private let fairPlayLicenseFetcher: FairPlayLicenseFetcher
	private let featureFlagProvider: FeatureFlagProvider
	let streamingSessionId: String

	// Improved DRM handling properties (only used when feature flag is enabled)
	private let drmQueue = DispatchQueue(label: "com.tidal.player.drm.streaming", qos: .userInitiated)
	private var pendingTasks: [AVContentKeyRequest: Task<Void, Never>] = [:]
	private let serialQueue = DispatchQueue(label: "com.tidal.player.drm.streaming.state", qos: .userInitiated)

	// Store strong references to sessions to prevent premature deallocation during async operations
	private var activeSessions: [AVContentKeyRequest: AVContentKeySession] = [:]

	// Legacy property
	private var pendingKeyRequest: AVContentKeyRequest?

	init(fairPlayLicenseFetcher: FairPlayLicenseFetcher, streamingSessionId: String, featureFlagProvider: FeatureFlagProvider) {
		self.fairPlayLicenseFetcher = fairPlayLicenseFetcher
		self.streamingSessionId = streamingSessionId
		self.featureFlagProvider = featureFlagProvider
	}

	func getLicense() async throws -> Data {
		if featureFlagProvider.shouldUseImprovedDRMHandling() {
			return try await getLicenseImproved()
		} else {
			return try await getLicenseLegacy()
		}
	}
	
	private func getLicenseImproved() async throws -> Data {
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
	
	private func getLicenseLegacy() async throws -> Data {
		guard let pendingKeyRequest else {
			throw LicenseLoaderError.missingLicense
		}

		return try await fairPlayLicenseFetcher.getLicense(
			streamingSessionId: streamingSessionId,
			keyRequest: pendingKeyRequest
		)
	}
	
	private func cleanupTask(for keyRequest: AVContentKeyRequest) {
		serialQueue.async {
			self.pendingTasks.removeValue(forKey: keyRequest)
			self.activeSessions.removeValue(forKey: keyRequest)
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
		if featureFlagProvider.shouldUseImprovedDRMHandling() {
			// CRITICAL: Retain the session to prevent deallocation during async operations
			// The keyRequest holds a weak reference to the session, so we must keep it alive
			serialQueue.async {
				self.activeSessions[keyRequest] = session
			}

			// Never block this method - it's called on AVFoundation's internal queue
			let task = Task {
				await handleKeyRequest(keyRequest)
			}

			serialQueue.async {
				self.pendingTasks[keyRequest] = task
			}
		} else {
			// Legacy behavior with semaphore
			contentKeySessionLegacy(session, didProvide: keyRequest)
		}
	}
	
	func contentKeySession(_ session: AVContentKeySession, contentKeyRequest keyRequest: AVContentKeyRequest, didFailWithError error: Error) {
		PlayerWorld.logger?.log(loggable: PlayerLoggable.streamingGetLicenseFailed(error: error))

		if featureFlagProvider.shouldUseImprovedDRMHandling() {
			// Check if this is a retryable error before cleaning up
			if shouldRetryDRMError(error) {
				// Keep the session alive for retry
				Task {
					await retryKeyRequestAfterDelay(keyRequest, session: session)
				}
			} else {
				// Non-retryable error - clean up immediately
				cleanupTask(for: keyRequest)
			}
		}
		// For legacy mode, no special handling needed
	}
	
	private func contentKeySessionLegacy(_ session: AVContentKeySession, didProvide keyRequest: AVContentKeyRequest) {
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
				PlayerWorld.logger?.log(loggable: PlayerLoggable.streamingGetLicenseFailed(error: error))
				keyRequest.processContentKeyResponseError(error)
			}
		}
		
		semaphore.wait()
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
