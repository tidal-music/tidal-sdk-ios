import AVFoundation
import CoreMedia
import Foundation

// MARK: - MediaDownloadResult

struct MediaDownloadResult {
	let mediaURL: URL
	let licenseURL: URL?
}

// MARK: - MediaDownloaderProtocol

protocol MediaDownloaderProtocol {
	func download(
		manifestURL: URL,
		taskId: String,
		onProgress: @escaping (Double) -> Void
	) async throws -> MediaDownloadResult
}

// MARK: - MediaDownloader

final class MediaDownloader: NSObject, MediaDownloaderProtocol {
	private let licenseFetcher: LicenseFetcher

	private lazy var session: AVAssetDownloadURLSession = {
		AVAssetDownloadURLSession(
			configuration: URLSessionConfiguration.background(withIdentifier: "com.tidal.offliner.download.session"),
			assetDownloadDelegate: self,
			delegateQueue: nil
		)
	}()

	private var activeDownloads: [Int: ActiveDownload] = [:]

	override init() {
		self.licenseFetcher = LicenseFetcher()
	}

	func download(
		manifestURL: URL,
		taskId: String,
		onProgress: @escaping (Double) -> Void
	) async throws -> MediaDownloadResult {
		let asset = AVURLAsset(url: manifestURL)

		return try await withCheckedThrowingContinuation { continuation in
			guard let task = session.makeAssetDownloadTask(
				asset: asset,
				assetTitle: taskId,
				assetArtworkData: nil,
				options: nil
			) else {
				continuation.resume(throwing: MediaDownloaderError.failedToCreateTask)
				return
			}

			let licenseQueue = DispatchQueue(label: "com.tidal.offliner.license.\(taskId)", qos: .userInitiated)
			let contentKeySession = AVContentKeySession(keySystem: .fairPlayStreaming)

			let activeDownload = ActiveDownload(
				taskId: taskId,
				continuation: continuation,
				onProgress: onProgress,
				contentKeySession: contentKeySession,
				licenseFetcher: licenseFetcher
			)

			contentKeySession.setDelegate(activeDownload, queue: licenseQueue)
			contentKeySession.addContentKeyRecipient(asset)

			activeDownloads[task.taskIdentifier] = activeDownload
			task.resume()
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
		activeDownloads[assetDownloadTask.taskIdentifier]?.downloadedLocation = location
	}

	func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		didCompleteWithError error: Error?
	) {
		guard let activeDownload = activeDownloads.removeValue(forKey: task.taskIdentifier) else {
			return
		}

		if let error {
			activeDownload.continuation.resume(throwing: error)
			return
		}

		guard let mediaURL = activeDownload.downloadedLocation else {
			activeDownload.continuation.resume(throwing: MediaDownloaderError.noDownloadedFile)
			return
		}

		if activeDownload.needsLicense && activeDownload.licenseLocation == nil {
			activeDownload.continuation.resume(throwing: MediaDownloaderError.licenseFailed)
			return
		}

		let result = MediaDownloadResult(
			mediaURL: mediaURL,
			licenseURL: activeDownload.licenseLocation
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
		guard let activeDownload = activeDownloads[assetDownloadTask.taskIdentifier] else {
			return
		}

		let loaded = loadedTimeRanges.reduce(0.0) { $0 + CMTimeGetSeconds($1.timeRangeValue.duration) }
		let expected = CMTimeGetSeconds(timeRangeExpectedToLoad.duration)
		let progress = expected > 0 ? loaded / expected : 0

		activeDownload.onProgress(progress)
	}
}

// MARK: - ActiveDownload

private final class ActiveDownload: NSObject {
	let taskId: String
	let continuation: CheckedContinuation<MediaDownloadResult, Error>
	let onProgress: (Double) -> Void
	let contentKeySession: AVContentKeySession
	let licenseFetcher: LicenseFetcher

	var downloadedLocation: URL?
	var licenseLocation: URL?
	var needsLicense: Bool = false

	init(
		taskId: String,
		continuation: CheckedContinuation<MediaDownloadResult, Error>,
		onProgress: @escaping (Double) -> Void,
		contentKeySession: AVContentKeySession,
		licenseFetcher: LicenseFetcher
	) {
		self.taskId = taskId
		self.continuation = continuation
		self.onProgress = onProgress
		self.contentKeySession = contentKeySession
		self.licenseFetcher = licenseFetcher
	}
}

// MARK: - AVContentKeySessionDelegate

extension ActiveDownload: AVContentKeySessionDelegate {
	func contentKeySession(
		_ session: AVContentKeySession,
		didProvide keyRequest: AVContentKeyRequest
	) {
		needsLicense = true

		do {
			try keyRequest.respondByRequestingPersistableContentKeyRequest()
		} catch {
			keyRequest.processContentKeyResponseError(error)
		}
	}

	func contentKeySession(
		_ session: AVContentKeySession,
		didProvide keyRequest: AVPersistableContentKeyRequest
	) {
		Task {
			do {
				let license = try await licenseFetcher.getLicense(for: keyRequest)
				licenseLocation = try FileStorage.store(license, subdirectory: "Licenses", filename: "\(UUID().uuidString).key")

				let keyResponse = AVContentKeyResponse(fairPlayStreamingKeyResponseData: license)
				keyRequest.processContentKeyResponse(keyResponse)
			} catch {
				keyRequest.processContentKeyResponseError(error)
			}
		}
	}

	func contentKeySession(
		_ session: AVContentKeySession,
		contentKeyRequest keyRequest: AVContentKeyRequest,
		didFailWithError error: Error
	) {
		keyRequest.processContentKeyResponseError(error)
	}
}

// MARK: - MediaDownloaderError

enum MediaDownloaderError: Error {
	case failedToCreateTask
	case noDownloadedFile
	case licenseFailed
}
