import AVFoundation
import Foundation

// MARK: - DownloadObserver

protocol DownloadObserver: AnyObject {
	func handle(streamingMetricsEvent: any StreamingMetricsEvent)
	func downloadCompleted(for mediaProduct: MediaProduct, storageItem: StorageItem)
	func downloadFailed(for mediaProduct: MediaProduct, with error: Error)
	func downloadProgress(for mediaProduct: MediaProduct, is percentage: Double)
}

// MARK: - Downloader

class Downloader {
	private let playbackInfoFetcher: PlaybackInfoFetcher
	private let fairPlayLicenseFetcher: FairPlayLicenseFetcher
	private let mediaDownloader: MediaDownloader
	private let networkMonitor: NetworkMonitor

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

	func download(mediaProduct: MediaProduct, sessionType: SessionType, outputDevice: String? = nil) {
		SafeTask {
			await start(DownloadTask(
				mediaProduct: mediaProduct,
				networkType: self.networkMonitor.getNetworkType(),
				outputDevice: outputDevice,
				sessionType: sessionType,
				monitor: self
			))
		}
	}

	func setObserver(observer: DownloadObserver) {
		self.observer = observer
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

	func progress(downloadTask: DownloadTask, progress: Double) {
		observer?.downloadProgress(for: downloadTask.mediaProduct, is: progress)
	}

	func failed(downloadTask: DownloadTask, with error: Error) {
		observer?.downloadFailed(for: downloadTask.mediaProduct, with: error)
	}

	func completed(downloadTask: DownloadTask, storageItem: StorageItem) {
		observer?.downloadCompleted(for: downloadTask.mediaProduct, storageItem: storageItem)
	}
}
