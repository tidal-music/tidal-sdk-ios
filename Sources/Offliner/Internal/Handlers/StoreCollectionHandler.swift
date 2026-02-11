import Foundation

final class StoreCollectionHandler {
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol

	init(backendClient: BackendClientProtocol, offlineStore: OfflineStore, artworkDownloader: ArtworkDownloaderProtocol) {
		self.backendClient = backendClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
	}

	func execute(_ task: StoreCollectionTask) async {
		do {
			try await backendClient.updateTask(taskId: task.id, state: .inProgress)

			let artworkURL = try await artworkDownloader.downloadArtwork(for: task)
			try offlineStore.storeCollection(task: task, artworkURL: artworkURL)

			try await backendClient.updateTask(taskId: task.id, state: .completed)
		} catch {
			print("StoreCollectionHandler error: \(error)")
			try? await backendClient.updateTask(taskId: task.id, state: .failed)
		}
	}
}
