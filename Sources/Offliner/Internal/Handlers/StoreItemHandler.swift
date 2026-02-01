import Auth
import AVFoundation
import CoreMedia
import Foundation

final class StoreItemHandler: NSObject {
	private let offlineRepository: OfflineRepository
	private let fairPlayLicenseFetcher: FairPlayLicenseFetcher
	private var licenseQueue: DispatchQueue
	private var downloadSession: AVAssetDownloadURLSession!

	private var pendingByUrlSessionTask: [URLSessionTask: PendingDownload] = [:]

	init(offlineRepository: OfflineRepository, credentialsProvider: CredentialsProvider) {
		self.offlineRepository = offlineRepository
		self.fairPlayLicenseFetcher = FairPlayLicenseFetcher(credentialsProvider: credentialsProvider)
		self.licenseQueue = DispatchQueue(label: "com.tidal.offliner.license", qos: .userInitiated)
		super.init()

		self.downloadSession = AVAssetDownloadURLSession(
			configuration: URLSessionConfiguration.background(withIdentifier: "com.tidal.offliner.download.session"),
			assetDownloadDelegate: self,
			delegateQueue: nil
		)
	}

	func start(
		_ mediaDownload: MediaDownload,
		onComplete: @escaping @Sendable () async -> Void,
		onFailure: @escaping @Sendable () async -> Void
	) {
		let asset = AVURLAsset(url: URL(string: "http://tidal.com/manifest.m3u8")!)
		let pending = PendingDownload(
			mediaDownload: mediaDownload,
			asset: asset,
			licenseQueue: licenseQueue,
			licenseFetcher: fairPlayLicenseFetcher,
			onComplete: onComplete,
			onFailure: onFailure
		)

		guard let urlSessionTask = downloadSession.makeAssetDownloadTask(
			asset: asset,
			assetTitle: mediaDownload.task.id,
			assetArtworkData: nil,
			options: nil
		) else {
			Task { await onFailure() }
			return
		}

		pendingByUrlSessionTask[urlSessionTask] = pending
		urlSessionTask.resume()
	}
}

// MARK: - AVAssetDownloadDelegate

extension StoreItemHandler: AVAssetDownloadDelegate {
	func urlSession(
		_ session: URLSession,
		assetDownloadTask: AVAssetDownloadTask,
		didFinishDownloadingTo location: URL
	) {
		pendingByUrlSessionTask[assetDownloadTask]?.mediaLocation = location
	}

	func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		didCompleteWithError error: Error?
	) {
		guard let pending = pendingByUrlSessionTask.removeValue(forKey: task) else {
			return
		}

		let download = pending.mediaDownload

		if error != nil {
			download.updateState(.failed)
			Task { await pending.onFailure() }
			return
		}

		guard let mediaLocation = pending.mediaLocation else {
			download.updateState(.failed)
			Task { await pending.onFailure() }
			return
		}

		if pending.needsLicense && pending.licenseLocation == nil {
			download.updateState(.failed)
			Task { await pending.onFailure() }
			return
		}

		let task = download.task
		do {
			try offlineRepository.storeMediaItem(
				id: task.id,
				mediaType: task.item.resourceType == "videos" ? .videos : .tracks,
				resourceId: task.item.resourceId,
				metadata: "",
				mediaURL: mediaLocation,
				licenseURL: pending.licenseLocation,
				collection: task.collectionId,
				volume: task.volume,
				position: task.index
			)
			download.updateState(.completed)
			Task { await pending.onComplete() }
		} catch {
			download.updateState(.failed)
			Task { await pending.onFailure() }
		}
	}

	func urlSession(
		_ session: URLSession,
		assetDownloadTask: AVAssetDownloadTask,
		didLoad timeRange: CMTimeRange,
		totalTimeRangesLoaded loadedTimeRanges: [NSValue],
		timeRangeExpectedToLoad: CMTimeRange
	) {
		guard let pending = pendingByUrlSessionTask[assetDownloadTask] else { return }

		let loaded = loadedTimeRanges.reduce(0.0) { $0 + CMTimeGetSeconds($1.timeRangeValue.duration) }
		let expected = CMTimeGetSeconds(timeRangeExpectedToLoad.duration)
		let progress = expected > 0 ? loaded / expected : 0

		pending.mediaDownload.updateProgress(progress)
	}
}

// MARK: - PendingDownload

private final class PendingDownload: NSObject {
	let mediaDownload: MediaDownload
	let contentKeySession: AVContentKeySession
	let licenseFetcher: FairPlayLicenseFetcher
	let onComplete: @Sendable () async -> Void
	let onFailure: @Sendable () async -> Void

	var mediaLocation: URL?
	var licenseLocation: URL?
	var needsLicense: Bool = false

	init(
		mediaDownload: MediaDownload,
		asset: AVURLAsset,
		licenseQueue: DispatchQueue,
		licenseFetcher: FairPlayLicenseFetcher,
		onComplete: @escaping @Sendable () async -> Void,
		onFailure: @escaping @Sendable () async -> Void
	) {
		self.mediaDownload = mediaDownload
		self.contentKeySession = AVContentKeySession(keySystem: .fairPlayStreaming)
		self.licenseFetcher = licenseFetcher
		self.onComplete = onComplete
		self.onFailure = onFailure
		super.init()

		contentKeySession.setDelegate(self, queue: licenseQueue)
		contentKeySession.addContentKeyRecipient(asset)
	}

	fileprivate func store(_ license: Data) throws {
		let licenseDirectory = FileManager.default
			.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
			.appendingPathComponent("DownloadedLicenses", isDirectory: true)

		try FileManager.default.createDirectory(at: licenseDirectory, withIntermediateDirectories: true)

		let url = licenseDirectory.appendingPathComponent("\(mediaDownload.task.id).key")
		try license.write(to: url, options: .atomic)

		licenseLocation = url
	}
}

// MARK: - AVContentKeySessionDelegate

extension PendingDownload: AVContentKeySessionDelegate {
	func contentKeySession(
		_ session: AVContentKeySession,
		didProvide keyRequest: AVContentKeyRequest
	) {
		needsLicense = true

		do {
			try keyRequest.respondByRequestingPersistableContentKeyRequestAndReturnError()
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
				try store(license)

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
