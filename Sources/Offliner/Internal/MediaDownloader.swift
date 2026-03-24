import AVFoundation
import CoreMedia
import Foundation
import OSLog

// MARK: - MediaDownloadResult

struct MediaDownloadResult {
	let duration: Int
	let mediaLocation: URL
}

// MARK: - MediaDownloaderProtocol

protocol MediaDownloaderProtocol {
	func download(
		taskId: String,
		manifestURL: URL,
		licenseDownloadResult: LicenseDownloadResult?,
		title: String,
		onProgress: @escaping @Sendable (Double) async -> Void
	) async throws -> MediaDownloadResult

	func handleBackgroundURLSessionEvents(identifier: String, completionHandler: @escaping () -> Void)
}

// MARK: - MediaDownloader

final class MediaDownloader: NSObject, MediaDownloaderProtocol {
	private static let logger = Logger(subsystem: "com.tidal.sdk.offliner", category: "MediaDownloader")
	static let backgroundSessionIdentifier = "com.tidal.offliner.download.session"

	private let queue: DispatchQueue
	private var session: AVAssetDownloadURLSession!
	private var activeDownloads: [Int: ActiveDownload] = [:]
	private var backgroundCompletionHandler: (() -> Void)?

	init(configuration: Configuration) {
		self.queue = DispatchQueue(label: "com.tidal.offliner.media-downloader", qos: .userInitiated)

		super.init()

		let delegateQueue = OperationQueue()
		delegateQueue.underlyingQueue = queue
		delegateQueue.maxConcurrentOperationCount = 1

		self.session = AVAssetDownloadURLSession(
			configuration: URLSessionConfiguration.background(withIdentifier: Self.backgroundSessionIdentifier),
			assetDownloadDelegate: self,
			delegateQueue: delegateQueue
		)
	}

	func handleBackgroundURLSessionEvents(identifier: String, completionHandler: @escaping () -> Void) {
		DispatchQueue.main.async {
			guard identifier == Self.backgroundSessionIdentifier else { return }
			self.backgroundCompletionHandler = completionHandler
		}
	}

	func download(
		taskId: String,
		manifestURL: URL,
		licenseDownloadResult: LicenseDownloadResult?,
		title: String,
		onProgress: @escaping @Sendable (Double) async -> Void
	) async throws -> MediaDownloadResult {
		Self.logger.debug("initiate download: \(title, privacy: .public) [task: \(taskId, privacy: .public)]")

		let asset = AVURLAsset(url: manifestURL)
		licenseDownloadResult?.contentKeySession.addContentKeyRecipient(asset)

		let duration = Int(CMTimeGetSeconds(try await asset.load(.duration)))

		return try await withCheckedThrowingContinuation { continuation in
			queue.async {
				guard let task = self.session.makeAssetDownloadTask(
					asset: asset,
					assetTitle: title,
					assetArtworkData: nil,
					options: nil
				) else {
					continuation.resume(throwing: MediaDownloaderError.failedToCreateTask)
					return
				}

				let activeDownload = ActiveDownload(
					duration: duration,
					continuation: continuation,
					onProgress: onProgress
				)

				task.taskDescription = taskId
				self.activeDownloads[task.taskIdentifier] = activeDownload
				task.resume()

				Self.logger.debug("started download [task: \(taskId, privacy: .public)]")
			}
		}
	}
}

// MARK: - AVAssetDownloadDelegate

extension MediaDownloader: AVAssetDownloadDelegate {
	func urlSession(
		_ session: URLSession,
		assetDownloadTask: AVAssetDownloadTask,
		didFinishDownloadingTo location: URL
	) {
		Self.logger.debug("didFinishDownloadingTo called [task: \(assetDownloadTask.taskDescription ?? "?", privacy: .public)]")

		guard let activeDownload = activeDownloads[assetDownloadTask.taskIdentifier] else {
			Self.logger.debug("orphaned didFinishDownloadingTo called [task: \(assetDownloadTask.taskDescription ?? "?", privacy: .public)]")

			try? FileStorage.delete(url: location)
			return
		}

		activeDownload.downloadedLocation = location
	}

	func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		didCompleteWithError error: Error?
	) {
		Self.logger.debug("didCompleteWithError called: \(error.map { "\($0)" } ?? "success", privacy: .public) [task: \(task.taskDescription ?? "?", privacy: .public)]")

		guard let activeDownload = activeDownloads.removeValue(forKey: task.taskIdentifier) else {
			Self.logger.debug("orphaned didCompleteWithError called [task: \(task.taskDescription ?? "?", privacy: .public)]")
			return
		}

		if let error {
			try? activeDownload.downloadedLocation.map(FileStorage.delete)
			activeDownload.continuation.resume(throwing: error)
			return
		}

		guard let mediaLocation = activeDownload.downloadedLocation else {
			activeDownload.continuation.resume(throwing: MediaDownloaderError.noDownloadedFile)
			return
		}

		let result = MediaDownloadResult(
			duration: activeDownload.duration,
			mediaLocation: mediaLocation
		)

		activeDownload.continuation.resume(returning: result)
	}

	func urlSession(
		_ session: URLSession,
		assetDownloadTask: AVAssetDownloadTask,
		didLoad timeRange: CMTimeRange,
		totalTimeRangesLoaded loadedTimeRanges: [NSValue],
		timeRangeExpectedToLoad: CMTimeRange
	) {
		let loaded = loadedTimeRanges.reduce(0.0) { $0 + CMTimeGetSeconds($1.timeRangeValue.duration) }
		let expected = CMTimeGetSeconds(timeRangeExpectedToLoad.duration)
		let progress = expected > 0 ? loaded / expected : 0

		if let onProgress = activeDownloads[assetDownloadTask.taskIdentifier]?.onProgress {
			Task { await onProgress(progress) }
		}
	}

	func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
		Self.logger.debug("urlSessionDidFinishEvents forBackgroundURLSession")
		DispatchQueue.main.async { [weak self] in
			self?.backgroundCompletionHandler?()
			self?.backgroundCompletionHandler = nil
		}
	}
}

// MARK: - ActiveDownload

private final class ActiveDownload {
	let duration: Int
	let continuation: CheckedContinuation<MediaDownloadResult, Error>
	let onProgress: @Sendable (Double) async -> Void

	var downloadedLocation: URL?

	init(
		duration: Int,
		continuation: CheckedContinuation<MediaDownloadResult, Error>,
		onProgress: @escaping @Sendable (Double) async -> Void
	) {
		self.duration = duration
		self.continuation = continuation
		self.onProgress = onProgress
	}
}

// MARK: - MediaDownloaderError

enum MediaDownloaderError: Error {
	case failedToCreateTask
	case noDownloadedFile
	case manifestNotFound
}
