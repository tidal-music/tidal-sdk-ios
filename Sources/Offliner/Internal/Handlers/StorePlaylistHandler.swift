import Foundation
import TidalAPI

final class StorePlaylistHandler {
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol

	init(offlineStore: OfflineStore, artworkDownloader: ArtworkDownloaderProtocol) {
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
	}

	func handle(_ task: StorePlaylistTask) -> InternalTask {
		InternalPlaylistTask(task: task, offlineStore: offlineStore, artworkDownloader: artworkDownloader)
	}
}

private final class InternalPlaylistTask: InternalTask {
	let id: String

	private let task: StorePlaylistTask
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol

	init(task: StorePlaylistTask, offlineStore: OfflineStore, artworkDownloader: ArtworkDownloaderProtocol) {
		self.id = task.id
		self.task = task
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
	}

	func run() async throws {
		let artworkURL = try await artworkDownloader.downloadArtwork(for: task.artwork)

		let catalogMetadata = OfflineCollection.Metadata.playlist(OfflineCollection.PlaylistMetadata(
			id: task.playlist.id,
			title: task.playlist.attributes?.name ?? ""
		))

		let result = StoreCollectionTaskResult(
			resourceType: .playlists,
			resourceId: task.playlist.id,
			catalogMetadata: catalogMetadata,
			artworkURL: artworkURL
		)

		try offlineStore.storeCollection(result)
	}
}
