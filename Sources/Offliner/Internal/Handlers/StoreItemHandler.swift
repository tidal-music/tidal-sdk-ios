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
		_ task: DownloadTask,
		completion: @escaping @Sendable (DownloadTask) async throws -> Void,
		failure: @escaping @Sendable (DownloadTask) async throws -> Void
	) {
		let asset = AVURLAsset(url: URL(string: "http://tidal.com/manifest.m3u8")!)
		let pending = PendingDownload(
			task: task,
			asset: asset,
			licenseQueue: licenseQueue,
			licenseFetcher: fairPlayLicenseFetcher,
			completion: completion,
			failure: failure)

		guard let urlSessionTask = downloadSession.makeAssetDownloadTask(
			asset: asset,
			assetTitle: task.id,
			assetArtworkData: nil,
			options: nil
		) else {
			Task { try? await failure(task) }
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
		guard let offlineTask = pendingByUrlSessionTask[task] else {
			return
		}

		if let error {
			offlineTask.task.updateState(.failed)
			Task { try? await offlineTask.failure(offlineTask.task) }
			return
		}

		guard let mediaLocation = offlineTask.mediaLocation else {
			offlineTask.task.updateState(.failed)
			Task { try? await offlineTask.failure(offlineTask.task) }
			return
		}

		if offlineTask.needsLicense && offlineTask.licenseLocation == nil {
			offlineTask.task.updateState(.failed)
			Task { try? await offlineTask.failure(offlineTask.task) }
			return
		}

		do {
			try offlineRepository.storeMediaItem(
				id: offlineTask.task.id,
				mediaType: offlineTask.task.resourceType == "videos" ? .videos : .tracks,
				resourceId: offlineTask.task.resourceId,
				metadata: "",
				mediaURL: mediaLocation,
				licenseURL: offlineTask.licenseLocation,
				collection: offlineTask.task.collectionId ?? offlineTask.task.id,
				volume: offlineTask.task.volume ?? 1,
				position: offlineTask.task.index ?? 0
			)
			offlineTask.task.updateState(.completed)
			Task { try? await offlineTask.completion(offlineTask.task) }
		} catch {
			offlineTask.task.updateState(.failed)
			Task { try? await offlineTask.failure(offlineTask.task) }
		}
	}

	func urlSession(
		_ session: URLSession,
		assetDownloadTask: AVAssetDownloadTask,
		didLoad timeRange: CMTimeRange,
		totalTimeRangesLoaded loadedTimeRanges: [NSValue],
		timeRangeExpectedToLoad: CMTimeRange
	) {
		guard let offlineTask = pendingByUrlSessionTask[assetDownloadTask] else { return }

		let loaded = loadedTimeRanges.reduce(0.0) { $0 + CMTimeGetSeconds($1.timeRangeValue.duration) }
		let expected = CMTimeGetSeconds(timeRangeExpectedToLoad.duration)
		let progress = expected > 0 ? loaded / expected : 0

		offlineTask.task.updateProgress(progress)
	}
}

// MARK: - PendingDownload

private final class PendingDownload: NSObject {
	let task: DownloadTask
	let contentKeySession: AVContentKeySession
	let licenseFetcher: FairPlayLicenseFetcher
	let completion: @Sendable (DownloadTask) async throws -> Void
	let failure: @Sendable (DownloadTask) async throws -> Void

	var mediaLocation: URL?
	var licenseLocation: URL?
	var needsLicense: Bool = false

	init(
		task: DownloadTask,
		asset: AVURLAsset,
		licenseQueue: DispatchQueue,
		licenseFetcher: FairPlayLicenseFetcher,
		completion: @escaping @Sendable (DownloadTask) async throws -> Void,
		failure: @escaping @Sendable (DownloadTask) async throws -> Void
	) {
		self.task = task
		self.contentKeySession = AVContentKeySession(keySystem: .fairPlayStreaming)
		self.licenseFetcher = licenseFetcher
		self.completion = completion
		self.failure = failure
		super.init()
		
		contentKeySession.setDelegate(self, queue: licenseQueue)
		contentKeySession.addContentKeyRecipient(asset)
	}
	
	private func store(_ license: Data) throws {
		let licenseDirectory = FileManager.default
			.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
			.appendingPathComponent("DownloadedLicenses", isDirectory: true)
		
		try FileManager.default.createDirectory(at: licenseDirectory, withIntermediateDirectories: true)
		
		let url = licenseDirectory.appendingPathComponent("\(task.id).key")
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
