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

	private weak var monitor: DownloadTaskMonitor?

	private let queue: OperationQueue

	var playbackInfo: PlaybackInfo?

	var startTimestamp: UInt64?
	private var endTimestamp: UInt64?
	private var error: Error?

	private var localAssetUrl: URL?
	private var localLicenseUrl: URL?
	private var localAssetSize: Int?

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
		queue.dispatch {
			self.localLicenseUrl = url
			self.finalize()
		}
	}

	func setMediaUrl(_ url: URL) {
		queue.dispatch {
			self.localAssetUrl = url
			self.localAssetSize = self.calculateSize()
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
				for: mediaProduct,
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
