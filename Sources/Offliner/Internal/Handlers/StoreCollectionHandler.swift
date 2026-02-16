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

	func handle(_ task: StoreCollectionTask) -> InternalTask {
		InternalTaskImpl(
			task: task,
			backendClient: backendClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader
		)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String

	private let task: StoreCollectionTask
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol

	init(
		task: StoreCollectionTask,
		backendClient: BackendClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol
	) {
		self.id = task.id
		self.task = task
		self.backendClient = backendClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
	}

	func run() async {
		do {
			try await backendClient.updateTask(taskId: id, state: .inProgress)

			let artworkURL = try await artworkDownloader.downloadArtwork(for: task)

			let result = StoreCollectionTaskResult(
				resourceType: task.metadata.resourceType,
				resourceId: task.metadata.resourceId,
				metadata: task.metadata,
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
