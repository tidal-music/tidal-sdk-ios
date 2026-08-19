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

	func handleBackgroundURLSessionEvents(identifier: String, completionHandler: @escaping () -> Void) -> Bool
	func cancelAll() async
}

// MARK: - MediaDownloader

final class MediaDownloader: NSObject, MediaDownloaderProtocol {
	private static let logger = Logger(subsystem: "com.tidal.sdk.offliner", category: "MediaDownloader")
	let backgroundSessionIdentifier: String

	private let queue: DispatchQueue
	private let fileStorage: FileStorage
	private var session: AVAssetDownloadURLSession!
	private var activeDownloads: [Int: ActiveDownload] = [:]
	private var backgroundCompletionHandler: (() -> Void)?
	private let cancellationLock = NSLock()
	private var isCancelled = false

	private static let isSimulator: Bool = {
		#if targetEnvironment(simulator)
			true
		#else
			false
		#endif
	}()

	var orphanedTaskHandler: ((String?) -> Void)?

	init(configuration: Configuration, backgroundSessionIdentifier: String, fileStorage: FileStorage) {
		queue = DispatchQueue(label: "com.tidal.offliner.media-downloader", qos: .userInitiated)
		self.backgroundSessionIdentifier = backgroundSessionIdentifier
		self.fileStorage = fileStorage

		super.init()

		let delegateQueue = OperationQueue()
		delegateQueue.underlyingQueue = queue
		delegateQueue.maxConcurrentOperationCount = 1

		session = AVAssetDownloadURLSession(
			configuration: URLSessionConfiguration.background(withIdentifier: backgroundSessionIdentifier),
			assetDownloadDelegate: self,
			delegateQueue: delegateQueue
		)
	}

	func handleBackgroundURLSessionEvents(identifier: String, completionHandler: @escaping () -> Void) -> Bool {
		guard identifier == backgroundSessionIdentifier else {
			return false
		}
		DispatchQueue.main.async {
			self.backgroundCompletionHandler = completionHandler
		}
		return true
	}

	func cancelAll() async {
		invalidate()
		let tasks = await session.allTasks
		for task in tasks {
			task.cancel()
		}
	}

	private func invalidate() {
		cancellationLock.lock()
		isCancelled = true
		cancellationLock.unlock()
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
		try Task.checkCancellation()

		if Self.isSimulator {
			return try await simulatorDownload(
				taskId: taskId,
				manifestURL: manifestURL,
				duration: duration,
				onProgress: onProgress
			)
		}

		return try await withCheckedThrowingContinuation { continuation in
			queue.async {
				self.cancellationLock.lock()
				let isCancelled = self.isCancelled
				self.cancellationLock.unlock()
				guard !isCancelled else {
					continuation.resume(throwing: CancellationError())
					return
				}
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

	/// `AVAssetDownloadURLSession` tasks never complete on simulators. Store the manifest itself as the media file so
	/// the download pipeline completes for development and UI validation; playback resolves the manifest's remote
	/// segment URLs over the network.
	private func simulatorDownload(
		taskId: String,
		manifestURL: URL,
		duration: Int,
		onProgress: @escaping @Sendable (Double) async -> Void
	) async throws -> MediaDownloadResult {
		Self.logger.warning(
			"Storing manifest instead of media segments: AVAssetDownloadTask is not supported on simulators [task: \(taskId, privacy: .public)]"
		)
		let (data, _) = try await URLSession.shared.data(from: manifestURL)
		try Task.checkCancellation()
		let location = try fileStorage.store(data, subdirectory: "Media", filename: "\(UUID().uuidString).m3u8")
		await onProgress(1.0)
		return MediaDownloadResult(duration: duration, mediaLocation: location)
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
	case previewManifest
}
