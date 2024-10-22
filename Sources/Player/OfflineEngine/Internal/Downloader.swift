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

	private var activeTasks: [String: SafeTask] = [:]

	private weak var observer: DownloadObserver?

	init(
		playbackInfoFetcher: PlaybackInfoFetcher,
		fairPlayLicenseFetcher: FairPlayLicenseFetcher,
		networkMonitor: NetworkMonitor
	) {
		self.playbackInfoFetcher = playbackInfoFetcher
		self.fairPlayLicenseFetcher = fairPlayLicenseFetcher
		mediaDownloader = MediaDownloader()
		self.networkMonitor = networkMonitor
	}

	func download(
		mediaProduct: MediaProduct,
		sessionType: SessionType,
		outputDevice: String? = nil
	) {
		let taskID = mediaProduct.productId
		let task = SafeTask {
			await start(DownloadTask(
				mediaProduct: mediaProduct,
				networkType: self.networkMonitor.getNetworkType(),
				outputDevice: outputDevice,
				sessionType: sessionType,
				monitor: self
			))
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

		if let licenseSecurityToken = playbackInfo.licenseSecurityToken {
			let licenseDownloader = LicenseDownloader(
				fairPlayLicenseFetcher: fairPlayLicenseFetcher,
				licenseSecurityToken: licenseSecurityToken,
				downloadTask: downloadTask
			)

			downloadTask.contentKeySession.setDelegate(licenseDownloader, queue: DispatchQueue.global(qos: .default))
			downloadTask.contentKeySession.addContentKeyRecipient(asset)
			downloadTask.licenseDownloader = licenseDownloader
		}

		downloadTask.playbackInfo = playbackInfo
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
