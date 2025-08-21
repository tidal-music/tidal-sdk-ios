import AVFoundation
import Foundation

// MARK: - DownloadObserver

protocol DownloadObserver: AnyObject {
	func handle(streamingMetricsEvent: any StreamingMetricsEvent)
	func downloadStarted(for mediaProduct: MediaProduct)
	func downloadProgress(for mediaProduct: MediaProduct, is percentage: Double)
	func downloadCompleted(for mediaProduct: MediaProduct, offlineEntry: OfflineEntry)
	func downloadFailed(for mediaProduct: MediaProduct, with error: Error)
}

// MARK: - Downloader

class Downloader {
	private let playbackInfoFetcher: PlaybackInfoFetcher
	private let fairPlayLicenseFetcher: FairPlayLicenseFetcher
	private let mediaDownloader: MediaDownloader
	private let networkMonitor: NetworkMonitor
	private let featureFlagProvider: FeatureFlagProvider
    private let stateManager: DownloadStateManager

	private var activeTasks: [String: SafeTask] = [:]

	private weak var observer: DownloadObserver?

	init(
		playbackInfoFetcher: PlaybackInfoFetcher,
		fairPlayLicenseFetcher: FairPlayLicenseFetcher,
		networkMonitor: NetworkMonitor,
		featureFlagProvider: FeatureFlagProvider,
        stateManager: DownloadStateManager
	) {
		self.playbackInfoFetcher = playbackInfoFetcher
		self.fairPlayLicenseFetcher = fairPlayLicenseFetcher
        self.stateManager = stateManager
		mediaDownloader = MediaDownloader()
		self.networkMonitor = networkMonitor
		self.featureFlagProvider = featureFlagProvider
	}

	func download(
		mediaProduct: MediaProduct,
		sessionType: SessionType,
		outputDevice: String? = nil
	) {
		let taskID = mediaProduct.productId
		let task = SafeTask {
            do {
                // Create or retrieve download entry from state manager
                let downloadEntry = try await self.stateManager.createDownload(
                    productId: mediaProduct.productId,
                    productType: mediaProduct.productType
                )
                
                // Start the download task with the download entry
                await self.start(DownloadTask(
                    mediaProduct: mediaProduct,
                    downloadEntry: downloadEntry,
                    networkType: self.networkMonitor.getNetworkType(),
                    outputDevice: outputDevice,
                    sessionType: sessionType,
                    monitor: self
                ))
            } catch {
                PlayerWorld.logger?.log(loggable: PlayerLoggable.downloadEntryCreationFailed(error: error))
                // We'll still try to start the download without state management
                await self.start(DownloadTask(
                    mediaProduct: mediaProduct,
                    downloadEntry: nil,
                    networkType: self.networkMonitor.getNetworkType(),
                    outputDevice: outputDevice,
                    sessionType: sessionType,
                    monitor: self
                ))
            }
		}
		activeTasks[taskID] = task
	}

	func cancellAll() {
		for (_, task) in activeTasks {
			task.cancel()
		}
		activeTasks.removeAll()
		mediaDownloader.cancelAll()
	}
    
    func cancelDownload(for productId: String) {
        // Cancel the active task if it exists
        if let task = activeTasks[productId] {
            task.cancel()
            activeTasks.removeValue(forKey: productId)
        }
        
        // Update the download state to cancelled
        do {
            if let downloadEntry = try stateManager.getDownloadByProductId(productId: productId) {
                _ = try stateManager.updateDownloadState(id: downloadEntry.id, state: .CANCELLED)
            }
        } catch {
            PlayerWorld.logger?.log(loggable: PlayerLoggable.cancelDownloadStateFailed(error: error))
        }
    }
    
    func cleanupStaleDownloads(olderThan days: Int = 7) {
        do {
            let threshold = TimeInterval(days * 24 * 60 * 60) // Convert days to seconds
            let deletedCount = try stateManager.cleanupStaleDownloads(threshold: threshold)
            if deletedCount > 0 {
                PlayerWorld.logger?.log(loggable: PlayerLoggable.cleanupStaleDownloads(count: deletedCount))
            }
        } catch {
            PlayerWorld.logger?.log(loggable: PlayerLoggable.cleanupStaleDownloadsFailed(error: error))
        }
    }

	func setObserver(observer: DownloadObserver) {
		self.observer = observer
	}

	func updateConfiguration(_ configuration: Configuration) {
		playbackInfoFetcher.updateConfiguration(configuration)
	}
}

private extension Downloader {
	func start(_ downloadTask: DownloadTask) async {
		do {
			let playbackInfo = try await playbackInfoFetcher.getPlaybackInfo(
				streamingSessionId: downloadTask.id,
				mediaProduct: downloadTask.mediaProduct,
				playbackMode: .OFFLINE
			)
			downloadMedia(for: downloadTask, using: playbackInfo)
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.startDownloadFailed(error: error))
			failed(downloadTask: downloadTask, with: error)
		}
	}

	func downloadMedia(for downloadTask: DownloadTask, using playbackInfo: PlaybackInfo) {
		downloadTask.startTimestamp = PlayerWorld.timeProvider.timestamp()
        
        // Update download state to IN_PROGRESS
        if let downloadEntry = downloadTask.downloadEntry {
            do {
                _ = try stateManager.updateDownloadState(id: downloadEntry.id, state: .IN_PROGRESS)
            } catch {
                PlayerWorld.logger?.log(loggable: PlayerLoggable.updateDownloadStateFailed(error: error))
            }
        }
        
		if playbackInfo.mediaType == MediaTypes.HLS ||
			(playbackInfo.productType == .VIDEO && playbackInfo.mediaType == MediaTypes.EMU)
		{
			downloadHls(for: downloadTask, using: playbackInfo)
		} else {
			downloadFile(for: downloadTask, using: playbackInfo)
		}
	}

	func downloadHls(for downloadTask: DownloadTask, using playbackInfo: PlaybackInfo) {
		let asset = AVURLAsset(url: playbackInfo.url)

		if let licenseSecurityToken = playbackInfo.licenseSecurityToken {
			// Create license downloader first
			let licenseDownloader = LicenseDownloader(
				fairPlayLicenseFetcher: fairPlayLicenseFetcher,
				licenseSecurityToken: licenseSecurityToken,
				downloadTask: downloadTask,
				featureFlagProvider: featureFlagProvider
			)

			// Apple's requirement: Set up content key session BEFORE any asset operations
			let drmQueue = DispatchQueue(label: "com.tidal.player.drm.download.\(downloadTask.id)", qos: .userInitiated)
			downloadTask.contentKeySession.setDelegate(licenseDownloader, queue: drmQueue)
			
			// Add content key recipient before starting download
			downloadTask.contentKeySession.addContentKeyRecipient(asset)
			downloadTask.licenseDownloader = licenseDownloader
			
			// Preload certificate to avoid delays during download
			Task {
				do {
					try await fairPlayLicenseFetcher.preloadCertificate()
				} catch {
					PlayerWorld.logger?.log(loggable: PlayerLoggable.getLicenseFailed(error: error))
				}
			}
		}

		downloadTask.playbackInfo = playbackInfo
		
		// Start media download only after DRM setup is complete
		mediaDownloader.download(asset: asset, for: downloadTask)
	}

	func downloadFile(for downloadTask: DownloadTask, using playbackInfo: PlaybackInfo) {
		downloadTask.playbackInfo = playbackInfo
		mediaDownloader.download(url: playbackInfo.url, for: downloadTask)
	}
}

// MARK: DownloadTaskMonitor

extension Downloader: DownloadTaskMonitor {
	func emit(event: any StreamingMetricsEvent) {
		observer?.handle(streamingMetricsEvent: event)
	}

	func started(downloadTask: DownloadTask) {
		observer?.downloadStarted(for: downloadTask.mediaProduct)
	}

	func progress(downloadTask: DownloadTask, progress: Double) {
        // Update download progress in state manager
        if let downloadEntry = downloadTask.downloadEntry {
            do {
                _ = try stateManager.updateDownloadProgress(id: downloadEntry.id, progress: progress)
            } catch {
                PlayerWorld.logger?.log(loggable: PlayerLoggable.updateDownloadProgressFailed(error: error))
            }
        }
        
		observer?.downloadProgress(for: downloadTask.mediaProduct, is: progress)
	}

	func completed(downloadTask: DownloadTask, offlineEntry: OfflineEntry) {
        // Update download state to COMPLETED
        if let downloadEntry = downloadTask.downloadEntry {
            do {
                _ = try stateManager.updateDownloadState(id: downloadEntry.id, state: .COMPLETED)
            } catch {
                PlayerWorld.logger?.log(loggable: PlayerLoggable.updateDownloadStateFailed(error: error))
            }
        }
        
		observer?.downloadCompleted(for: downloadTask.mediaProduct, offlineEntry: offlineEntry)
	}

	func failed(downloadTask: DownloadTask, with error: Error) {
        // Record error and update state to FAILED
        if let downloadEntry = downloadTask.downloadEntry {
            do {
                _ = try stateManager.recordDownloadError(id: downloadEntry.id, error: error)
            } catch {
                PlayerWorld.logger?.log(loggable: PlayerLoggable.recordDownloadErrorFailed(originalError: error, stateError: error))
            }
        }
        
		observer?.downloadFailed(for: downloadTask.mediaProduct, with: error)
	}
}

// MARK: - PlayerLoggable Extension for Download State Management

extension PlayerLoggable {
    static func downloadEntryCreationFailed(error: Error) -> PlayerLoggable {
        PlayerLoggable(message: "Failed to create download entry", technicalMessage: error.localizedDescription)
    }
    
    static func updateDownloadStateFailed(error: Error) -> PlayerLoggable {
        PlayerLoggable(message: "Failed to update download state", technicalMessage: error.localizedDescription)
    }
    
    static func updateDownloadProgressFailed(error: Error) -> PlayerLoggable {
        PlayerLoggable(message: "Failed to update download progress", technicalMessage: error.localizedDescription)
    }
    
    static func recordDownloadErrorFailed(originalError: Error, stateError: Error) -> PlayerLoggable {
        PlayerLoggable(message: "Failed to record download error", technicalMessage: "Original error: \(originalError.localizedDescription), State error: \(stateError.localizedDescription)")
    }
    
    static func cancelDownloadStateFailed(error: Error) -> PlayerLoggable {
        PlayerLoggable(message: "Failed to cancel download state", technicalMessage: error.localizedDescription)
    }
    
    static func cleanupStaleDownloads(count: Int) -> PlayerLoggable {
        PlayerLoggable(message: "Cleaned up stale downloads", technicalMessage: "Deleted \(count) stale downloads")
    }
    
    static func cleanupStaleDownloadsFailed(error: Error) -> PlayerLoggable {
        PlayerLoggable(message: "Failed to cleanup stale downloads", technicalMessage: error.localizedDescription)
    }
}