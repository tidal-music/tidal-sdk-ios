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

	private var activeTasks: [String: SafeTask] = [:]

	private weak var observer: DownloadObserver?

	init(
		playbackInfoFetcher: PlaybackInfoFetcher,
		fairPlayLicenseFetcher: FairPlayLicenseFetcher,
		networkMonitor: NetworkMonitor,
		featureFlagProvider: FeatureFlagProvider
	) {
		self.playbackInfoFetcher = playbackInfoFetcher
		self.fairPlayLicenseFetcher = fairPlayLicenseFetcher
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
		let downloadTask = DownloadTask(
			mediaProduct: mediaProduct,
			networkType: networkMonitor.getNetworkType(),
			outputDevice: outputDevice,
			sessionType: sessionType,
			monitor: self
		)
		let task = SafeTask {
			await self.start(downloadTask)
		}
		activeTasks[taskID] = task
	}

	func cancel(mediaProduct: MediaProduct) -> Bool {
		let taskID = mediaProduct.productId
		guard let task = activeTasks[taskID] else {
			return false
		}
		task.cancel()
		activeTasks.removeValue(forKey: taskID)
		mediaDownloader.cancel(for: mediaProduct)
		return true
	}

	func cancellAll() {
		for (_, task) in activeTasks {
			task.cancel()
		}
		activeTasks.removeAll()
		mediaDownloader.cancelAll()
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

		if playbackInfo
			.licenseSecurityToken != nil || (playbackInfo.productType == .TRACK && featureFlagProvider.shouldUseNewPlaybackEndpoints())
		{
			// Create license downloader first
			let licenseDownloader = LicenseDownloader(
				fairPlayLicenseFetcher: fairPlayLicenseFetcher,
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
		observer?.downloadProgress(for: downloadTask.mediaProduct, is: progress)
	}

	func completed(downloadTask: DownloadTask, offlineEntry: OfflineEntry) {
		observer?.downloadCompleted(for: downloadTask.mediaProduct, offlineEntry: offlineEntry)
	}

	func failed(downloadTask: DownloadTask, with error: Error) {
		observer?.downloadFailed(for: downloadTask.mediaProduct, with: error)
	}
}
