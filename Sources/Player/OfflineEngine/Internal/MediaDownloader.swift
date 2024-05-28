import AVFoundation
import Foundation

// MARK: - MediaDownloader

final class MediaDownloader: NSObject {
	private var tasks: [URLSessionTask: DownloadTask]
	private var hlsDownloadSession: AVAssetDownloadURLSession!
	private var urlDownloadSession: URLSession!

	override init() {
		tasks = [URLSessionTask: DownloadTask]()
		let operationQueue = OperationQueue()

		super.init()
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
		guard let task = createTask(for: asset) else {
			return
		}

		tasks[task] = downloadTask
		task.resume()
	}

	func download(url: URL, for downloadTask: DownloadTask) {
		let task = createTask(for: url)

		tasks[task] = downloadTask
		task.resume()
	}
}

private extension MediaDownloader {
	func createTask(for asset: AVURLAsset) -> AVAssetDownloadTask? {
		let uuid = PlayerWorld.uuidProvider.uuidString()
		return hlsDownloadSession.makeAssetDownloadTask(
			asset: asset,
			assetTitle: uuid,
			assetArtworkData: nil,
			options: nil
		)
	}

	func createTask(for url: URL) -> URLSessionDownloadTask {
		urlDownloadSession.downloadTask(with: url)
	}
}

// MARK: AVAssetDownloadDelegate, URLSessionDownloadDelegate

extension MediaDownloader: AVAssetDownloadDelegate, URLSessionDownloadDelegate {
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		defer {
			tasks.removeValue(forKey: task)
		}

		guard let error else {
			return
		}

		tasks[task]?.failed(with: error)
	}

	func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
		defer {
			tasks.removeValue(forKey: assetDownloadTask)
		}

		tasks[assetDownloadTask]?.setMediaUrl(location)
	}

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		defer {
			tasks.removeValue(forKey: downloadTask)
		}

		do {
			let uuid = PlayerWorld.uuidProvider.uuidString()
			let fileManager = PlayerWorld.fileManagerClient
			let url = fileManager.cachesDirectory().appendingPathComponent(uuid)
			try fileManager.moveFile(location, url)
			tasks[downloadTask]?.setMediaUrl(url)
		} catch {
			tasks[downloadTask]?.failed(with: error)
		}
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

		tasks[assetDownloadTask]?.reportProgress(loadedDuration / expectedDuration)
	}

	func urlSession(
		_ session: URLSession,
		downloadTask: URLSessionDownloadTask,
		didWriteData bytesWritten: Int64,
		totalBytesWritten: Int64,
		totalBytesExpectedToWrite: Int64
	) {
		tasks[downloadTask]?.reportProgress(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
	}
}
