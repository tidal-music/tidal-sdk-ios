import AVFoundation
import Foundation

// MARK: - MediaDownloader

final class MediaDownloader: NSObject {
	private var activeTasks: [URLSessionTask: DownloadTask] = [:]
	private var hlsDownloadSession: AVAssetDownloadURLSession!
	private var urlDownloadSession: URLSession!

	override init() {
		super.init()
		let operationQueue = OperationQueue()
		hlsDownloadSession = AVAssetDownloadURLSession(
			configuration: URLSessionConfiguration.background(withIdentifier: "com.tidal.player.downloader.hls"),
			assetDownloadDelegate: self,
			delegateQueue: operationQueue
		)
		urlDownloadSession = URLSession(
			configuration: URLSessionConfiguration.background(withIdentifier: "com.tidal.player.downloader.progressive"),
			delegate: self,
			delegateQueue: operationQueue
		)
	}

	func download(asset: AVURLAsset, for downloadTask: DownloadTask) {
		guard let task = createTask(for: asset, downloadTask) else {
			return
		}

		activeTasks[task] = downloadTask
		task.resume()
	}

	func download(url: URL, for downloadTask: DownloadTask) {
		let task = createTask(for: url)

		activeTasks[task] = downloadTask
		task.resume()
	}

	func cancel(for mediaProduct: MediaProduct) {
		for (urlTask, downloadTask) in activeTasks {
			if downloadTask.mediaProduct.productId == mediaProduct.productId {
				downloadTask.cancel()
				urlTask.cancel()
				activeTasks.removeValue(forKey: urlTask)
				break
			}
		}
	}

	func cancelAll() {
		for (task, downloadTask) in activeTasks {
			downloadTask.cancel()
			task.cancel()
		}
	}
}

private extension MediaDownloader {
	func createTask(for asset: AVURLAsset, _ downloadTask: DownloadTask) -> AVAssetDownloadTask? {
		let type = downloadTask.mediaProduct.productType.rawValue.lowercased()
		let title = "\(type)-offlined-\(downloadTask.mediaProduct.productId)"
		return hlsDownloadSession.makeAssetDownloadTask(
			asset: asset,
			assetTitle: title,
			assetArtworkData: nil
		)
	}

	func createTask(for url: URL) -> URLSessionDownloadTask {
		urlDownloadSession.downloadTask(with: url)
	}
}

// MARK: URLSessionDownloadDelegate

extension MediaDownloader: URLSessionDownloadDelegate {
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		guard let error else {
			return
		}

		defer {
			activeTasks.removeValue(forKey: task)
		}

		activeTasks[task]?.failed(with: error)
	}

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		defer {
			activeTasks.removeValue(forKey: downloadTask)
		}

		do {
			let fileManager = PlayerWorld.fileManagerClient
			let appSupportURL = fileManager.applicationSupportDirectory()
			let directoryURL = appSupportURL.appendingPathComponent("ProgressiveDownloads", isDirectory: true)
			try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)

			let uuid = PlayerWorld.uuidProvider.uuidString()
			let url = directoryURL.appendingPathComponent(uuid)

			try fileManager.moveFile(location, url)

			let task = activeTasks[downloadTask]
			task?.setMediaUrl(url)
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.downloadFinishedMovingFileFailed(error: error))
			activeTasks[downloadTask]?.failed(with: error)
		}
	}

	func urlSession(
		_ session: URLSession,
		downloadTask: URLSessionDownloadTask,
		didWriteData bytesWritten: Int64,
		totalBytesWritten: Int64,
		totalBytesExpectedToWrite: Int64
	) {
		let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
		activeTasks[downloadTask]?.reportProgress(progress)
	}
}

// MARK: AVAssetDownloadDelegate

extension MediaDownloader: AVAssetDownloadDelegate {
	func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
		defer {
			activeTasks.removeValue(forKey: assetDownloadTask)
		}

		let task = activeTasks[assetDownloadTask]
		task?.setMediaUrl(location)
	}

	func urlSession(
		_ session: URLSession,
		assetDownloadTask: AVAssetDownloadTask,
		didLoad timeRange: CMTimeRange,
		totalTimeRangesLoaded loadedTimeRanges: [NSValue],
		timeRangeExpectedToLoad: CMTimeRange
	) {
		let loadedDuration = loadedTimeRanges
			.map { $0.timeRangeValue }
			.map { CMTimeGetSeconds(CMTimeAdd($0.start, $0.duration)) }
			.max() ?? 0.0

		let expectedDuration = CMTimeGetSeconds(
			CMTimeAdd(
				timeRangeExpectedToLoad.start,
				timeRangeExpectedToLoad.duration
			)
		)

		let progress = loadedDuration / expectedDuration
		activeTasks[assetDownloadTask]?.reportProgress(progress)
	}
}
