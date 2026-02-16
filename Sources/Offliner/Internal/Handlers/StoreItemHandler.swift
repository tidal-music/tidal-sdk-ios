import AVFoundation
import CoreMedia
import Foundation

final class StoreItemHandler {
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol

	init(
		backendClient: BackendClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.backendClient = backendClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
	}

	func handle(_ task: StoreItemTask) -> InternalTask {
		InternalTaskImpl(
			task: task,
			download: Download(metadata: task.itemMetadata),
			backendClient: backendClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader
		)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String
	let download: Download?

	private let task: StoreItemTask
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol

	private var mediaDownload: Download { download! }

	init(
		task: StoreItemTask,
		download: Download,
		backendClient: BackendClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.id = task.id
		self.task = task
		self.download = download
		self.backendClient = backendClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
	}

	func run() async {
		do {
			try await backendClient.updateTask(taskId: id, state: .inProgress)
			await mediaDownload.updateState(.inProgress)
		} catch {
			print("StoreItemHandler error: \(error)")
			await mediaDownload.updateState(.failed)
			return
		}

		do {
			let artworkURL = try await artworkDownloader.downloadArtwork(for: task)

			let mediaResult = try await mediaDownloader.download(
				trackId: task.itemMetadata.resourceId,
				taskId: id,
				onProgress: { [weak self] progress in
					guard let download = self?.download else { return }
					await download.updateProgress(progress)
				}
			)

			let storeResult = StoreItemTaskResult(
				resourceType: task.itemMetadata.resourceType,
				resourceId: task.itemMetadata.resourceId,
				metadata: task.itemMetadata,
				collectionResourceType: task.collectionMetadata.resourceType,
				collectionResourceId: task.collectionMetadata.resourceId,
				volume: task.volume,
				position: task.position,
				mediaURL: mediaResult.mediaLocation,
				licenseURL: mediaResult.licenseLocation,
				artworkURL: artworkURL
			)

			try offlineStore.storeMediaItem(storeResult)

			try await backendClient.updateTask(taskId: id, state: .completed)
			await mediaDownload.updateState(.completed)
		} catch {
			print("StoreItemHandler error: \(error)")
			try? await backendClient.updateTask(taskId: id, state: .failed)
			await mediaDownload.updateState(.failed)
		}
	}
}
