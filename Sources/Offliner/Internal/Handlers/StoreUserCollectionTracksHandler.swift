import Foundation
import TidalAPI

final class StoreUserCollectionTracksHandler {
	private let offlineStore: OfflineStore

	init(offlineStore: OfflineStore) {
		self.offlineStore = offlineStore
	}

	func handle(_ task: StoreUserCollectionTracksTask) -> InternalTask {
		InternalUserCollectionTracksTask(task: task, offlineStore: offlineStore)
	}
}

private final class InternalUserCollectionTracksTask: InternalTask {
	let id: String

	private let task: StoreUserCollectionTracksTask
	private let offlineStore: OfflineStore

	init(task: StoreUserCollectionTracksTask, offlineStore: OfflineStore) {
		self.id = task.id
		self.task = task
		self.offlineStore = offlineStore
	}

	func run() async throws {
		let result = StoreCollectionTaskResult(
			resourceType: .userCollectionTracks,
			resourceId: task.userCollectionTracks.id,
			catalogMetadata: .userCollectionTracks(id: task.userCollectionTracks.id),
			artworkURL: nil
		)

		try offlineStore.storeCollection(result)
	}
}
