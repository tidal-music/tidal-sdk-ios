import Foundation
import TidalAPI

final class StoreUserCollectionTracksHandler {
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore

	init(offlineApiClient: OfflineApiClientProtocol, offlineStore: OfflineStore) {
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
	}

	func handle(_ task: StoreUserCollectionTracksTask) -> InternalTask {
		InternalTaskImpl(
			task: task,
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore
		)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String

	private let task: StoreUserCollectionTracksTask
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore

	init(
		task: StoreUserCollectionTracksTask,
		offlineApiClient: OfflineApiClientProtocol,
		offlineStore: OfflineStore
	) {
		self.id = task.id
		self.task = task
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
	}

	func run() async {
		do {
			try await offlineApiClient.updateTask(taskId: id, state: .inProgress)

			let result = StoreCollectionTaskResult(
				resourceType: OfflineCollectionType.userCollectionTracks.rawValue,
				resourceId: task.userCollectionTracks.id,
				catalogMetadata: .userCollectionTracks(id: task.userCollectionTracks.id),
				artworkURL: nil
			)

			try offlineStore.storeCollection(result)

			try await offlineApiClient.updateTask(taskId: id, state: .completed)
		} catch {
			print("StoreUserCollectionTracksHandler error: \(error)")
			try? await offlineApiClient.updateTask(taskId: id, state: .failed)
		}
	}
}
