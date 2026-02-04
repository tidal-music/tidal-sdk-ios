import Auth
import AVFoundation
import CoreMedia
import Foundation

final class StoreItemHandler {
	private let backendRepository: BackendRepositoryProtocol
	private let localRepository: LocalRepository
	private let artworkDownloader: ArtworkRepositoryProtocol
	private let mediaDownloader: MediaDownloaderProtocol

	init(
		backendRepository: BackendRepositoryProtocol,
		localRepository: LocalRepository,
		artworkDownloader: ArtworkRepositoryProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.backendRepository = backendRepository
		self.localRepository = localRepository
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
	}

	func start(_ download: Download, onFinished: @escaping @Sendable () async -> Void) async {
		let task = download.task

		do {
			try await backendRepository.updateTask(taskId: task.id, state: .inProgress)
			download.updateState(.inProgress)
		} catch {
			await onFinished()
			return
		}

		do {
			let artworkURL = try await artworkDownloader.downloadArtwork(for: task)

			let result = try await mediaDownloader.download(
				manifestURL: URL(string: "http://tidal.com/manifest.m3u8")!,
				taskId: task.id,
				onProgress: { progress in
					download.updateProgress(progress)
				}
			)

			try localRepository.storeMediaItem(
				task: task,
				mediaURL: result.mediaURL,
				licenseURL: result.licenseURL,
				artworkURL: artworkURL
			)

			try await backendRepository.updateTask(taskId: task.id, state: .completed)
			download.updateState(.completed)
		} catch {
			try? await backendRepository.updateTask(taskId: task.id, state: .failed)
			download.updateState(.failed)
		}

		await onFinished()
	}
}

// MARK: - MediaDownloaderProtocol

struct MediaDownloadResult {
	let mediaURL: URL
	let licenseURL: URL?
}

protocol MediaDownloaderProtocol {
	func download(
		manifestURL: URL,
		taskId: String,
		onProgress: @escaping (Double) -> Void
	) async throws -> MediaDownloadResult
}

// MARK: - MediaDownloader

final class MediaDownloader: NSObject, MediaDownloaderProtocol {
	private let licenseRepository: LicenseRepository

	private lazy var session: AVAssetDownloadURLSession = {
		AVAssetDownloadURLSession(
			configuration: URLSessionConfiguration.background(withIdentifier: "com.tidal.offliner.download.session"),
			assetDownloadDelegate: self,
			delegateQueue: nil
		)
	}()

	private var activeDownloads: [Int: ActiveDownload] = [:]

	init(credentialsProvider: CredentialsProvider) {
		self.licenseRepository = LicenseRepository(credentialsProvider: credentialsProvider)
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
				licenseRepository: licenseRepository
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

		// Check if license was required but failed
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
	let licenseRepository: LicenseRepository

	var downloadedLocation: URL?
	var licenseLocation: URL?
	var needsLicense: Bool = false

	init(
		taskId: String,
		continuation: CheckedContinuation<MediaDownloadResult, Error>,
		onProgress: @escaping (Double) -> Void,
		contentKeySession: AVContentKeySession,
		licenseRepository: LicenseRepository
	) {
		self.taskId = taskId
		self.continuation = continuation
		self.onProgress = onProgress
		self.contentKeySession = contentKeySession
		self.licenseRepository = licenseRepository
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
				let license = try await licenseRepository.getLicense(for: keyRequest)
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
