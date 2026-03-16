import Foundation
import TidalAPI

final class StoreAlbumHandler {
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol

	init(offlineStore: OfflineStore, artworkDownloader: ArtworkDownloaderProtocol) {
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
	}

	func handle(_ task: StoreAlbumTask) -> InternalTask {
		InternalAlbumTask(task: task, offlineStore: offlineStore, artworkDownloader: artworkDownloader)
	}
}

private final class InternalAlbumTask: InternalTask {
	let id: String

	private let task: StoreAlbumTask
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol

	init(task: StoreAlbumTask, offlineStore: OfflineStore, artworkDownloader: ArtworkDownloaderProtocol) {
		self.id = task.id
		self.task = task
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
	}

	func run() async throws {
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
			resourceType: .albums,
			resourceId: task.album.id,
			catalogMetadata: catalogMetadata,
			artworkURL: artworkURL
		)

		try offlineStore.storeCollection(result)
	}
}
