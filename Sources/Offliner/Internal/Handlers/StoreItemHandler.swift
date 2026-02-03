import Auth
import AVFoundation
import CoreMedia
import Foundation

final class StoreItemHandler: NSObject {
	private let backendRepository: BackendRepository
	private let localRepository: LocalRepository
	private let licenseRepository: LicenseRepository
	private let artworkRepository: ArtworkRepository
	private var licenseQueue: DispatchQueue
	private var downloadSession: AVAssetDownloadURLSession!

	private var pendingByUrlSessionTask: [URLSessionTask: PendingDownload] = [:]

	init(backendRepository: BackendRepository, localRepository: LocalRepository, artworkRepository: ArtworkRepository, credentialsProvider: CredentialsProvider) {
		self.backendRepository = backendRepository
		self.localRepository = localRepository
		self.artworkRepository = artworkRepository
		self.licenseRepository = LicenseRepository(credentialsProvider: credentialsProvider)
		self.licenseQueue = DispatchQueue(label: "com.tidal.offliner.license", qos: .userInitiated)
		super.init()

		self.downloadSession = AVAssetDownloadURLSession(
			configuration: URLSessionConfiguration.background(withIdentifier: "com.tidal.offliner.download.session"),
			assetDownloadDelegate: self,
			delegateQueue: nil
		)
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

		let asset = AVURLAsset(url: URL(string: "http://tidal.com/manifest.m3u8")!)
		let pending = PendingDownload(
			download: download,
			asset: asset,
			licenseQueue: licenseQueue,
			licenseRepository: licenseRepository,
			backendRepository: backendRepository,
			localRepository: localRepository,
			onFinished: onFinished
		)

		do {
			pending.artworkLocation = try await artworkRepository.downloadArtwork(for: task)
		} catch {
			pending.fail()
			return
		}

		guard let urlSessionTask = downloadSession.makeAssetDownloadTask(
			asset: asset,
			assetTitle: task.id,
			assetArtworkData: nil,
			options: nil
		) else {
			pending.fail()
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

		if error != nil {
			pending.fail()
			return
		}

		pending.complete()
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

		pending.download.updateProgress(progress)
	}
}

// MARK: - PendingDownload

private final class PendingDownload: NSObject {
	let download: Download
	let contentKeySession: AVContentKeySession
	let licenseRepository: LicenseRepository
	let backendRepository: BackendRepository
	let localRepository: LocalRepository
	let onFinished: @Sendable () async -> Void

	var artworkLocation: URL?
	var mediaLocation: URL?
	var licenseLocation: URL?
	var needsLicense: Bool = false

	private var task: StoreItemTask { download.task }

	init(
		download: Download,
		asset: AVURLAsset,
		licenseQueue: DispatchQueue,
		licenseRepository: LicenseRepository,
		backendRepository: BackendRepository,
		localRepository: LocalRepository,
		onFinished: @escaping @Sendable () async -> Void
	) {
		self.download = download
		self.contentKeySession = AVContentKeySession(keySystem: .fairPlayStreaming)
		self.licenseRepository = licenseRepository
		self.backendRepository = backendRepository
		self.localRepository = localRepository
		self.onFinished = onFinished
		super.init()

		contentKeySession.setDelegate(self, queue: licenseQueue)
		contentKeySession.addContentKeyRecipient(asset)
	}

	func complete() {
		guard let mediaLocation, let artworkLocation else {
			fail()
			return
		}

		if needsLicense && licenseLocation == nil {
			fail()
			return
		}

		Task {
			do {
				try localRepository.storeMediaItem(
					task: task,
					mediaURL: mediaLocation,
					licenseURL: licenseLocation,
					artworkURL: artworkLocation
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

	func fail() {
		Task {
			try? await backendRepository.updateTask(taskId: task.id, state: .failed)
			download.updateState(.failed)
			await onFinished()
		}
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
				licenseLocation = try FileRepository.store(license, subdirectory: "Licenses", filename: "\(task.id).key")

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
