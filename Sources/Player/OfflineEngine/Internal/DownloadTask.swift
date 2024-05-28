import AVFoundation
import Foundation

// MARK: - DownloadTaskMonitor

protocol DownloadTaskMonitor: AnyObject {
	func emit(event: any StreamingMetricsEvent)
	func failed(downloadTask: DownloadTask, with error: Error)
	func progress(downloadTask: DownloadTask, progress: Double)
	func completed(downloadTask: DownloadTask, storageItem: StorageItem)
}

// MARK: - DownloadTask

final class DownloadTask {
	let id: String
	let mediaProduct: MediaProduct
	let contentKeySession: AVContentKeySession
	var licenseDownloader: LicenseDownloader?

	private weak var monitor: DownloadTaskMonitor?

	var playbackInfo: PlaybackInfo?

	var startTimestamp: UInt64?
	private var endTimestamp: UInt64?
	private var error: Error?

	private var localAssetUrl: URL?
	private var localLicenseUrl: URL?

	init(
		mediaProduct: MediaProduct,
		networkType: NetworkType,
		outputDevice: String?,
		sessionType: SessionType,
		monitor: DownloadTaskMonitor
	) {
		id = PlayerWorld.uuidProvider.uuidString()

		self.mediaProduct = mediaProduct
		self.monitor = monitor

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

	func setLicenseUrl(_ url: URL) {
		localLicenseUrl = url
		finalize()
	}

	func setMediaUrl(_ url: URL) {
		localAssetUrl = url
		finalize()
	}

	func reportProgress(_ progress: Double) {
		monitor?.progress(downloadTask: self, progress: progress)
	}

	func failed(with error: Error) {
		self.error = error
		endTimestamp = PlayerWorld.timeProvider.timestamp()

		monitor?.failed(downloadTask: self, with: error)

		guard let localAssetUrl, let localLicenseUrl else {
			return
		}

		do {
			let fileManager = PlayerWorld.fileManagerClient
			try fileManager.removeItem(at: localAssetUrl)
			try fileManager.removeItem(at: localLicenseUrl)
		} catch {
			print("Failed to remove item: \(error)")
		}
	}
}

private extension DownloadTask {
	func finalize() {
		guard let playbackInfo, let localAssetUrl else {
			return
		}

		guard licenseDownloader == nil || localLicenseUrl != nil else {
			return
		}

		do {
			let storageItem = try StorageItem(from: playbackInfo, with: localAssetUrl, and: localLicenseUrl)
			monitor?.completed(downloadTask: self, storageItem: storageItem)
			endTimestamp = PlayerWorld.timeProvider.timestamp()
		} catch {
			failed(with: error)
		}
	}
}
