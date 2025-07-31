import AVFoundation
import Foundation

// MARK: - LicenseDownloader

final class LicenseDownloader: NSObject {
	private let fairPlayLicenseFetcher: FairPlayLicenseFetcher
	private let licenseSecurityToken: String
	private let downloadTaskId: String
	private weak var downloadTask: DownloadTask?

	private let drmQueue = DispatchQueue(label: "com.tidal.player.drm.offline", qos: .userInitiated)
	private var pendingTasks: [AVContentKeyRequest: Task<Void, Never>] = [:]
	private let serialQueue = DispatchQueue(label: "com.tidal.player.drm.offline.state", qos: .userInitiated)

	init(
		fairPlayLicenseFetcher: FairPlayLicenseFetcher,
		licenseSecurityToken: String,
		downloadTask: DownloadTask
	) {
		self.fairPlayLicenseFetcher = fairPlayLicenseFetcher
		self.licenseSecurityToken = licenseSecurityToken
		self.downloadTaskId = downloadTask.id
		self.downloadTask = downloadTask
	}

	private func store(_ persistableKey: Data, for downloadTask: DownloadTask) throws {
		let uuid = PlayerWorld.uuidProvider.uuidString()
		let appSupportURL = PlayerWorld.fileManagerClient.applicationSupportDirectory()
		let directoryURL = appSupportURL.appendingPathComponent("PlayerOfflineLicenses", isDirectory: true)
		try PlayerWorld.fileManagerClient.createDirectory(at: directoryURL, withIntermediateDirectories: true)
		let url = directoryURL.appendingPathComponent("\(uuid).license")
		try persistableKey.write(to: url, options: .atomic)
		downloadTask.setLicenseUrl(url)
	}
	
	private func cleanupTask(for keyRequest: AVContentKeyRequest) {
		serialQueue.async {
			self.pendingTasks.removeValue(forKey: keyRequest)
		}
	}
}

// MARK: AVContentKeySessionDelegate

extension LicenseDownloader: AVContentKeySessionDelegate {
	func contentKeySession(_ session: AVContentKeySession, didProvide keyRequest: AVContentKeyRequest) {
		// Capture strong reference early to avoid weak reference becoming nil
		guard let downloadTask = self.downloadTask else {
			let error = PlayerInternalError(
				errorId: .PERetryable,
				errorType: .drmLicenseError,
				code: -1,
				description: "Download task was deallocated during content key request"
			)
			PlayerWorld.logger?.log(loggable: PlayerLoggable.licenseDownloaderContentKeyRequestFailed(error: error))
			keyRequest.processContentKeyResponseError(error)
			return
		}
		
		do {
			#if os(iOS)
				try keyRequest.respondByRequestingPersistableContentKeyRequestAndReturnError()
			#else
				try keyRequest.respondByRequestingPersistableContentKeyRequest()
			#endif
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.licenseDownloaderContentKeyRequestFailed(error: error))
			downloadTask.failed(with: error)
		}
	}

	func contentKeySession(_ session: AVContentKeySession, didProvide keyRequest: AVPersistableContentKeyRequest) {
		// Never block this method - it's called on AVFoundation's internal queue
		let task = Task {
			await handlePersistableKeyRequest(keyRequest)
		}
		
		serialQueue.async {
			self.pendingTasks[keyRequest] = task
		}
	}
	
	func contentKeySession(_ session: AVContentKeySession, contentKeyRequest keyRequest: AVContentKeyRequest, didFailWithError error: Error) {
		PlayerWorld.logger?.log(loggable: PlayerLoggable.licenseDownloaderGetLicenseFailed(error: error))
		cleanupTask(for: keyRequest)
		
		// Notify download task of failure
		downloadTask?.failed(with: error)
	}
	
	private func handlePersistableKeyRequest(_ keyRequest: AVPersistableContentKeyRequest) async {
		defer {
			cleanupTask(for: keyRequest)
		}
		
		do {
			// Capture strong reference early to avoid weak reference becoming nil
			guard let downloadTask = self.downloadTask else {
				let error = PlayerInternalError(
					errorId: .PERetryable,
					errorType: .drmLicenseError,
					code: -2,
					description: "Download task was deallocated during license fetch"
				)
				keyRequest.processContentKeyResponseError(error)
				return
			}

			// Get persistable license data from server 
			// Note: FairPlayLicenseFetcher.getLicense() already creates the persistable key for AVPersistableContentKeyRequest
			let persistableKey = try await fairPlayLicenseFetcher.getLicense(
				streamingSessionId: downloadTaskId,
				keyRequest: keyRequest
			)
			
			// Check if task was cancelled before processing response
			try Task.checkCancellation()
			
			// Store persistable key
			try store(persistableKey, for: downloadTask)
			
			// Create response with persistable key data
			let response = AVContentKeyResponse(fairPlayStreamingKeyResponseData: persistableKey)
			keyRequest.processContentKeyResponse(response)

		} catch is CancellationError {
			// Don't call processContentKeyResponseError for cancellation
			return
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.licenseDownloaderGetLicenseFailed(error: error))
			keyRequest.processContentKeyResponseError(error)
			
			// Also notify download task of failure
			downloadTask?.failed(with: error)
		}
	}
}
