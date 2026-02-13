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

	func handle(_ task: StoreCollectionTask) async -> InternalTask? {
		guard let metadata = task.metadata else {
			print("StoreCollectionHandler error: missing metadata")
			try? await backendClient.updateTask(taskId: task.id, state: .failed)
			return nil
		}

		return InternalTaskImpl(
			task: task,
			metadata: metadata,
			backendClient: backendClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader
		)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String

	private let task: StoreCollectionTask
	private let metadata: OfflineCollection.Metadata
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol

	init(
		task: StoreCollectionTask,
		metadata: OfflineCollection.Metadata,
		backendClient: BackendClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol
	) {
		self.id = task.id
		self.task = task
		self.metadata = metadata
		self.backendClient = backendClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
	}

	func run() async {
		do {
			try await backendClient.updateTask(taskId: id, state: .inProgress)

			let artworkURL = try await artworkDownloader.downloadArtwork(for: task)

			let result = StoreCollectionTaskResult(
				resourceType: metadata.resourceType,
				resourceId: metadata.resourceId,
				metadata: metadata,
				artworkURL: artworkURL
			)

			try offlineStore.storeCollection(result)

			try await backendClient.updateTask(taskId: id, state: .completed)
		} catch {
			print("StoreCollectionHandler error: \(error)")
			try? await backendClient.updateTask(taskId: id, state: .failed)
		}
	}
}
