import Foundation
import TidalAPI

final class StoreAlbumHandler {
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol

	init(offlineApiClient: OfflineApiClientProtocol, offlineStore: OfflineStore, artworkDownloader: ArtworkDownloaderProtocol) {
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
	}

	func handle(_ task: StoreAlbumTask) -> InternalTask {
		InternalTaskImpl(
			task: task,
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader
		)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String

	private let task: StoreAlbumTask
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol

	init(
		task: StoreAlbumTask,
		offlineApiClient: OfflineApiClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol
	) {
		self.id = task.id
		self.task = task
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
	}

	func run() async {
		do {
			try await offlineApiClient.updateTask(taskId: id, state: .inProgress)

			let artworkURL = try await artworkDownloader.downloadArtwork(for: task.artwork)

			let catalogMetadata = OfflineCollection.Metadata.album(OfflineCollection.AlbumMetadata(
				id: task.album.id,
				title: task.album.attributes?.title ?? "",
				artists: task.artists.compactMap(\.attributes?.name),
				copyright: task.album.attributes?.copyright?.text,
				releaseDate: task.album.attributes?.releaseDate,
				explicit: task.album.attributes?.explicit ?? false
			))

			let result = StoreCollectionTaskResult(
				resourceType: OfflineCollectionType.albums.rawValue,
				resourceId: task.album.id,
				catalogMetadata: catalogMetadata,
				artworkURL: artworkURL
			)

			try offlineStore.storeCollection(result)

			try await offlineApiClient.updateTask(taskId: id, state: .completed)
		} catch {
			print("StoreAlbumHandler error: \(error)")
			try? await offlineApiClient.updateTask(taskId: id, state: .failed)
		}
	}
}
