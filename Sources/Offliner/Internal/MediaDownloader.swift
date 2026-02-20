import AVFoundation
import CoreMedia
import Foundation
import TidalAPI

// MARK: - MediaDownloadResult

struct MediaDownloadResult {
	let requiresLicense: Bool
	let mediaLocation: URL
	let licenseLocation: URL?
	let playbackMetadata: OfflineMediaItem.PlaybackMetadata?
}

// MARK: - MediaDownloaderProtocol

protocol MediaDownloaderProtocol {
	var audioFormats: [AudioFormat] { get set }

	func download(
		trackId: String,
		taskId: String,
		onProgress: @escaping @Sendable (Double) async -> Void
	) async throws -> MediaDownloadResult
}

// MARK: - MediaDownloader

final class MediaDownloader: NSObject, MediaDownloaderProtocol {
	var audioFormats: [AudioFormat]
	private let licenseFetcher: LicenseFetcher
	private let queue: DispatchQueue
	private var session: AVAssetDownloadURLSession!
	private var activeDownloads: [Int: ActiveDownload] = [:]

	init(configuration: Configuration) {
		self.audioFormats = configuration.audioFormats
		self.licenseFetcher = LicenseFetcher()
		self.queue = DispatchQueue(label: "com.tidal.offliner.media-downloader", qos: .userInitiated)

		super.init()

		let delegateQueue = OperationQueue()
		delegateQueue.underlyingQueue = queue
		delegateQueue.maxConcurrentOperationCount = 1

		self.session = AVAssetDownloadURLSession(
			configuration: URLSessionConfiguration.background(withIdentifier: "com.tidal.offliner.download.session"),
			assetDownloadDelegate: self,
			delegateQueue: delegateQueue
		)
	}

	func download(
		trackId: String,
		taskId: String,
		onProgress: @escaping @Sendable (Double) async -> Void
	) async throws -> MediaDownloadResult {
		let (manifestURL, contentKeySession, playbackMetadata) = try await fetchManifestURL(trackId: trackId)
		let asset = AVURLAsset(url: manifestURL)
		contentKeySession?.addContentKeyRecipient(asset)

		return try await withCheckedThrowingContinuation { continuation in
			queue.async {
				guard let task = self.session.makeAssetDownloadTask(
					asset: asset,
					assetTitle: taskId,
					assetArtworkData: nil,
					options: nil
				) else {
					continuation.resume(throwing: MediaDownloaderError.failedToCreateTask)
					return
				}

				let activeDownload = ActiveDownload(
					taskId: taskId,
					continuation: continuation,
					onProgress: onProgress,
					contentKeySession: contentKeySession,
					licenseFetcher: self.licenseFetcher,
					queue: self.queue,
					playbackMetadata: playbackMetadata
				)

				contentKeySession?.setDelegate(activeDownload, queue: self.queue)

				self.activeDownloads[task.taskIdentifier] = activeDownload
				task.resume()
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

		Task { [weak self] in
			// Wait for license fetch to complete if needed
			let licenseLocation = await activeDownload.licenseTask?.value

			self?.queue.async {
				activeDownload.contentKeySession?.setDelegate(nil, queue: nil)

				if let error {
					activeDownload.continuation.resume(throwing: error)
					return
				}

				guard let mediaLocation = activeDownload.downloadedLocation else {
					activeDownload.continuation.resume(throwing: MediaDownloaderError.noDownloadedFile)
					return
				}

				if activeDownload.licenseTask != nil && licenseLocation == nil {
					activeDownload.continuation.resume(throwing: MediaDownloaderError.licenseFailed)
					return
				}

				let result = MediaDownloadResult(
					requiresLicense: activeDownload.licenseTask != nil,
					mediaLocation: mediaLocation,
					licenseLocation: licenseLocation,
					playbackMetadata: activeDownload.playbackMetadata
				)
				activeDownload.continuation.resume(returning: result)
			}
		}
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
}

// MARK: - ActiveDownload

private final class ActiveDownload: NSObject {
	let taskId: String
	let continuation: CheckedContinuation<MediaDownloadResult, Error>
	let onProgress: @Sendable (Double) async -> Void
	let contentKeySession: AVContentKeySession?
	let licenseFetcher: LicenseFetcher
	let queue: DispatchQueue
	let playbackMetadata: OfflineMediaItem.PlaybackMetadata?

	var downloadedLocation: URL?
	var licenseTask: Task<URL?, Never>?

	init(
		taskId: String,
		continuation: CheckedContinuation<MediaDownloadResult, Error>,
		onProgress: @escaping @Sendable (Double) async -> Void,
		contentKeySession: AVContentKeySession?,
		licenseFetcher: LicenseFetcher,
		queue: DispatchQueue,
		playbackMetadata: OfflineMediaItem.PlaybackMetadata?
	) {
		self.taskId = taskId
		self.continuation = continuation
		self.onProgress = onProgress
		self.contentKeySession = contentKeySession
		self.licenseFetcher = licenseFetcher
		self.queue = queue
		self.playbackMetadata = playbackMetadata
	}
}

// MARK: - AVContentKeySessionDelegate

extension ActiveDownload: AVContentKeySessionDelegate {
	func contentKeySession(
		_ session: AVContentKeySession,
		didProvide keyRequest: AVContentKeyRequest
	) {
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
		licenseTask = Task { [weak self] in
			guard let self else { return nil }

			do {
				let license = try await licenseFetcher.getLicense(for: keyRequest)
				let url = try FileStorage.store(
					license,
					subdirectory: "Licenses",
					filename: "\(UUID().uuidString).key"
				)

				queue.async {
					let keyResponse = AVContentKeyResponse(fairPlayStreamingKeyResponseData: license)
					keyRequest.processContentKeyResponse(keyResponse)
				}

				return url
			} catch {
				queue.async {
					keyRequest.processContentKeyResponseError(error)
				}
				return nil
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

// MARK: - Private Helpers

private extension MediaDownloader {
	func fetchManifestURL(trackId: String) async throws -> (URL, AVContentKeySession?, OfflineMediaItem.PlaybackMetadata?) {
		let response = try await TrackManifestsAPITidal.trackManifestsIdGet(
			id: trackId,
			manifestType: .hls,
			formats: audioFormats.map(\.toAPIFormat),
			uriScheme: .data,
			usage: .download,
			adaptive: false
		)

		let attributes = response.data.attributes

		guard let uriString = attributes?.uri,
			  let url = URL(string: uriString) else {
			throw MediaDownloaderError.manifestNotFound
		}

		let contentKeySession = attributes?.drmData
			.map { _ in AVContentKeySession(keySystem: .fairPlayStreaming)}

		let format = attributes?.formats?.first.flatMap { AudioFormat(rawValue: $0.rawValue) }

		let playbackMetadata = format.map { format in
			OfflineMediaItem.PlaybackMetadata(
				format: format,
				albumNormalizationData: .init(attributes?.albumAudioNormalizationData),
				trackNormalizationData: .init(attributes?.trackAudioNormalizationData)
			)
		}

		return (url, contentKeySession, playbackMetadata)
	}
}

private extension OfflineMediaItem.NormalizationData {
	init?(_ apiData: AudioNormalizationData?) {
		guard let apiData else { return nil }
		self.init(peakAmplitude: apiData.peakAmplitude, replayGain: apiData.replayGain)
	}
}

// MARK: - MediaDownloaderError

enum MediaDownloaderError: Error {
	case failedToCreateTask
	case noDownloadedFile
	case licenseFailed
	case manifestNotFound
}
