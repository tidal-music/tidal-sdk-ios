import Foundation
import TidalAPI

final class StorePlaylistHandler {
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol

	init(offlineApiClient: OfflineApiClientProtocol, offlineStore: OfflineStore, artworkDownloader: ArtworkDownloaderProtocol) {
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
	}

	func handle(_ task: StorePlaylistTask) -> InternalTask {
		InternalPlaylistTask(
			task: task,
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader
		)
	}
}

private final class InternalPlaylistTask: InternalTask {
	let id: String

	private let task: StorePlaylistTask
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol

	init(
		task: StorePlaylistTask,
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

			try await offlineApiClient.updateTask(taskId: id, state: .completed)
		} catch {
			print("StorePlaylistHandler error: \(error)")
			try? await offlineApiClient.updateTask(taskId: id, state: .failed)
		}
	}
}
