import AVFoundation
import CoreMedia
import Foundation
import TidalAPI

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
		let metadata = OfflineMediaItem.Metadata(from: task)
		let imageURL = task.artwork?.attributes?.files.first.flatMap { URL(string: $0.href) }
		return InternalTaskImpl(
			task: task,
			download: Download(metadata: metadata, imageURL: imageURL),
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
				metadata: OfflineMediaItem.Metadata(from: task),
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

// MARK: - Metadata Conversion

private extension OfflineMediaItem.Metadata {
	init(from task: StoreItemTask) {
		let artistNames = task.artists.compactMap(\.attributes?.name)
		switch task.itemMetadata {
		case .track(let track):
			self = .track(OfflineMediaItem.TrackMetadata(
				id: track.id,
				title: track.attributes?.title ?? "",
				artists: artistNames,
				duration: track.attributes?.duration ?? ""
			))
		case .video(let video):
			self = .video(OfflineMediaItem.VideoMetadata(
				id: video.id,
				title: video.attributes?.title ?? "",
				artists: artistNames,
				duration: video.attributes?.duration ?? ""
			))
		}
	}
}
