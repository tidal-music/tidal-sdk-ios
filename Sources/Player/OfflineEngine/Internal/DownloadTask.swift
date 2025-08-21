import AVFoundation
import Foundation

// MARK: - DownloadTaskMonitor

protocol DownloadTaskMonitor: AnyObject {
	func emit(event: any StreamingMetricsEvent)
	func started(downloadTask: DownloadTask)
	func progress(downloadTask: DownloadTask, progress: Double)
	func completed(downloadTask: DownloadTask, offlineEntry: OfflineEntry)
	func failed(downloadTask: DownloadTask, with error: Error)
}

// MARK: - DownloadTask

final class DownloadTask {
	let id: String
	let mediaProduct: MediaProduct
	let contentKeySession: AVContentKeySession
	var licenseDownloader: LicenseDownloader?
    
    /// Optional download entry for state persistence
    let downloadEntry: DownloadEntry?

	private weak var monitor: DownloadTaskMonitor?

	private let queue: OperationQueue

	var playbackInfo: PlaybackInfo?

	var startTimestamp: UInt64?
	private var endTimestamp: UInt64?
	private var error: Error?

	private var localAssetUrl: URL?
	private var localLicenseUrl: URL?
	private var localAssetSize: Int?
    
    /// Initialize the download task with optional download entry for state persistence
	init(
		mediaProduct: MediaProduct,
        downloadEntry: DownloadEntry? = nil,
		networkType: NetworkType,
		outputDevice: String?,
		sessionType: SessionType,
		monitor: DownloadTaskMonitor
	) {
		id = PlayerWorld.uuidProvider.uuidString()
		self.mediaProduct = mediaProduct
        self.downloadEntry = downloadEntry
		self.monitor = monitor

		queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1
		queue.qualityOfService = .userInitiated

		contentKeySession = AVContentKeySession(keySystem: .fairPlayStreaming)

		let now = PlayerWorld.timeProvider.timestamp()
		monitor.emit(event: StreamingSessionStart(
			streamingSessionId: id,
			startReason: .EXPLICIT,
			timestamp: now,
			networkType: networkType,
			outputDevice: outputDevice,
			sessionType: sessionType,
			sessionProductType: mediaProduct.productType.rawValue,
			sessionProductId: mediaProduct.productId
		))
        
        // Notify that download has started
        monitor.started(downloadTask: self)
	}

	deinit {
		if let playbackInfo, let startTimestamp {
			let actualQuality = playbackInfo.audioQuality?.rawValue ?? (playbackInfo.videoQuality?.rawValue ?? "NA")

			let endReason = error != nil ? EndReason.ERROR : (endTimestamp != nil ? EndReason.COMPLETE : EndReason.OTHER)
			let playerError = error != nil ? PlayerInternalError.from(error!) : nil

			let endTime = endTimestamp ?? PlayerWorld.timeProvider.timestamp()

			monitor?.emit(event: DownloadStatistics(
				streamingSessionId: id,
				startTimestamp: startTimestamp,
				productType: playbackInfo.productType.rawValue,
				actualProductId: playbackInfo.productId,
				actualAssetPresentation: playbackInfo.assetPresentation.rawValue,
				actualAudioMode: playbackInfo.audioMode?.rawValue,
				actualQuality: actualQuality,
				endReason: endReason.rawValue,
				endTimestamp: endTime,
				errorMessage: playerError?.technicalDescription,
				errorCode: playerError?.code
			))
		}

		let now = PlayerWorld.timeProvider.timestamp()
		monitor?.emit(event: StreamingSessionEnd(streamingSessionId: id, timestamp: now))
	}
    
    /// Returns the current progress of the download
    var progress: Double {
        return downloadEntry?.progress ?? 0.0
    }
    
    /// Returns the current state of the download
    var state: DownloadState? {
        return downloadEntry?.state
    }
    
    /// Returns true if this download has been attempted before
    var isRetry: Bool {
        return downloadEntry != nil && downloadEntry!.attemptCount > 0
    }
    
    /// Returns the number of download attempts
    var attemptCount: Int {
        return downloadEntry?.attemptCount ?? 0
    }
    
    /// Returns the last error encountered during download
    var lastError: String? {
        return downloadEntry?.lastError
    }

	func setLicenseUrl(_ url: URL) {
		queue.dispatch {
			self.localLicenseUrl = url
            
            // Store the partial license path in the download entry
            if let downloadEntry = self.downloadEntry {
                // We store the path in the task itself; the download state manager
                // is responsible for persisting this information
                downloadEntry.partialLicensePath = url.path
            }
            
			self.finalize()
		}
	}

	func setMediaUrl(_ url: URL) {
		queue.dispatch {
			self.localAssetUrl = url
			self.localAssetSize = self.calculateSize()
            
            // Store the partial media path in the download entry
            if let downloadEntry = self.downloadEntry {
                // We store the path in the task itself; the download state manager
                // is responsible for persisting this information
                downloadEntry.partialMediaPath = url.path
            }
            
			self.finalize()
		}
	}

	func reportProgress(_ progress: Double) {
		queue.dispatch {
			self.monitor?.progress(downloadTask: self, progress: progress)
		}
	}

	func failed(with error: Error) {
		queue.dispatch {
			self.error = error
			self.endTimestamp = PlayerWorld.timeProvider.timestamp()

			let fileManager = PlayerWorld.fileManagerClient
			if let localAssetUrl = self.localAssetUrl {
				try? fileManager.removeItem(at: localAssetUrl)
			}
			if let localLicenseUrl = self.localLicenseUrl {
				try? fileManager.removeItem(at: localLicenseUrl)
			}

			PlayerWorld.logger?.log(loggable: PlayerLoggable.downloadFailed(error: error))
			self.monitor?.failed(downloadTask: self, with: error)
		}
	}
    
    /// Cancels the download
    func cancel() {
        queue.dispatch {
            // We don't need to delete partial files here since they'll be cleaned up 
            // during state cleanup or when the download is restarted
            self.monitor?.failed(downloadTask: self, with: DownloadError.cancelled)
        }
    }
    
    /// Pauses the download (for future implementation)
    func pause() {
        // This is a placeholder for future implementation
        // We'll need to update the state manager and handle partial downloads
        queue.dispatch {
            // For now, treat pause as cancel
            self.cancel()
        }
    }
}

private extension DownloadTask {
	func calculateSize() -> Int {
		guard let playbackInfo, let localAssetUrl else {
			return 0
		}

		if playbackInfo.mediaType == MediaTypes.HLS ||
			(playbackInfo.productType == .VIDEO && playbackInfo.mediaType == MediaTypes.EMU)
		{
			return calculateHLSStreamSize(for: localAssetUrl)
		} else {
			return calculateProgressiveFileSize(for: localAssetUrl)
		}
	}

	func calculateHLSStreamSize(for path: URL) -> Int {
		var totalSize: Int = 0

		if let enumerator = PlayerWorld.fileManagerClient.enumerator(
			at: path,
			includingPropertiesForKeys: [URLResourceKey.fileSizeKey]
		) {
			for case let fileURL as URL in enumerator {
				do {
					let fileAttributes = try fileURL.resourceValues(forKeys: [URLResourceKey.fileSizeKey])
					if let fileSize = fileAttributes.fileSize {
						totalSize += Int(fileSize)
					}
				} catch {
					PlayerWorld.logger?.log(loggable: PlayerLoggable.failedToCalculateSizeForHLSDownload(error: error))
				}
			}
		}

		return totalSize
	}

	func calculateProgressiveFileSize(for path: URL) -> Int {
		do {
			let fileAttributes = try FileManager.default.attributesOfItem(atPath: path.path)
			if let fileSize = fileAttributes[.size] as? Int {
				return fileSize
			}
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.failedToCalculateSizeForProgressiveDownload(error: error))
		}
		return 0
	}

	func finalize() {
		guard let playbackInfo, let localAssetUrl, let localAssetSize else {
			return
		}

		guard licenseDownloader == nil || (licenseDownloader != nil && localLicenseUrl != nil) else {
			return
		}

		do {
			let offlineEntry = try OfflineEntry(
				for: mediaProduct.productId,
				from: playbackInfo,
				with: localAssetUrl,
				and: localLicenseUrl,
				size: localAssetSize
			)
			monitor?.completed(downloadTask: self, offlineEntry: offlineEntry)
			endTimestamp = PlayerWorld.timeProvider.timestamp()
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.downloadFinalizeFailed(error: error))
			failed(with: error)
		}
	}
}

/// Errors specific to the download process
enum DownloadError: Error {
    case cancelled
    case paused
    case networkUnavailable
    case insufficientSpace
    case invalidState
}

extension DownloadError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cancelled:
            return "Download was cancelled by the user"
        case .paused:
            return "Download was paused"
        case .networkUnavailable:
            return "Network is unavailable"
        case .insufficientSpace:
            return "Insufficient storage space"
        case .invalidState:
            return "Invalid download state"
        }
    }
}