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

	var orphanedTaskHandler: ((String?) -> Void)?

	init(configuration: Configuration) {
		queue = DispatchQueue(label: "com.tidal.offliner.media-downloader", qos: .userInitiated)

		super.init()

		let delegateQueue = OperationQueue()
		delegateQueue.underlyingQueue = queue
		delegateQueue.maxConcurrentOperationCount = 1

		session = AVAssetDownloadURLSession(
			configuration: URLSessionConfiguration.background(withIdentifier: Self.backgroundSessionIdentifier),
			assetDownloadDelegate: self,
			delegateQueue: delegateQueue
		)
	}

	func handleBackgroundURLSessionEvents(identifier: String, completionHandler: @escaping () -> Void) {
		DispatchQueue.main.async {
			guard identifier == Self.backgroundSessionIdentifier else {
				return
			}
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

		let duration = try await Int(CMTimeGetSeconds(asset.load(.duration)))

		return try await withCheckedThrowingContinuation { continuation in
			queue.async {
				let downloadConfiguration = AVAssetDownloadConfiguration(asset: asset, title: title)
				let task = self.session.makeAssetDownloadTask(downloadConfiguration: downloadConfiguration)

				let activeDownload = ActiveDownload(
					duration: duration,
					continuation: continuation
				)

				task.taskDescription = taskId
				task.priority = 1.0

				activeDownload.progressObservation = task.progress.observe(\.fractionCompleted) { progress, _ in
					Task { await onProgress(progress.fractionCompleted) }
				}

				self.activeDownloads[task.taskIdentifier] = activeDownload
				task.resume()

				Self.logger.debug("started download [task: \(taskId, privacy: .public), state: \(task.state.rawValue, privacy: .public)]")
			}
		}
	}
}

// MARK: AVAssetDownloadDelegate

extension MediaDownloader: AVAssetDownloadDelegate {
	func urlSession(
		_ session: URLSession,
		assetDownloadTask: AVAssetDownloadTask,
		didFinishDownloadingTo location: URL
	) {
		Self.logger.debug("didFinishDownloadingTo called [task: \(assetDownloadTask.taskDescription ?? "?", privacy: .public)]")
		recordDownloadedLocation(location, for: assetDownloadTask, deleteIfOrphaned: true)
	}

	@available(iOS 18.0, macOS 14.0, watchOS 10.0, *)
	func urlSession(
		_ session: URLSession,
		assetDownloadTask: AVAssetDownloadTask,
		willDownloadTo location: URL
	) {
		Self.logger.debug("willDownloadTo called [task: \(assetDownloadTask.taskDescription ?? "?", privacy: .public)]")
		recordDownloadedLocation(location, for: assetDownloadTask, deleteIfOrphaned: false)
	}

	private func recordDownloadedLocation(
		_ location: URL,
		for assetDownloadTask: AVAssetDownloadTask,
		deleteIfOrphaned: Bool
	) {
		guard let activeDownload = activeDownloads[assetDownloadTask.taskIdentifier] else {
			Self.logger.debug("orphaned download location [task: \(assetDownloadTask.taskDescription ?? "?", privacy: .public)]")
			if deleteIfOrphaned {
				try? FileStorage.delete(url: location)
			}
			return
		}

		activeDownload.downloadedLocation = location
	}

	func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		didCompleteWithError error: Error?
	) {
		Self.logger
			.debug(
				"didCompleteWithError called: \(error.map { "\($0)" } ?? "success", privacy: .public) [task: \(task.taskDescription ?? "?", privacy: .public)]"
			)

		guard let activeDownload = activeDownloads.removeValue(forKey: task.taskIdentifier) else {
			Self.logger.debug("orphaned didCompleteWithError called [task: \(task.taskDescription ?? "?", privacy: .public)]")
			orphanedTaskHandler?(task.taskDescription)
			return
		}

		activeDownload.progressObservation?.invalidate()

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

	var downloadedLocation: URL?
	var progressObservation: NSKeyValueObservation?

	init(
		duration: Int,
		continuation: CheckedContinuation<MediaDownloadResult, Error>
	) {
		self.duration = duration
		self.continuation = continuation
	}
}

// MARK: - MediaDownloaderError

enum MediaDownloaderError: Error {
	case noDownloadedFile
	case manifestNotFound
}
