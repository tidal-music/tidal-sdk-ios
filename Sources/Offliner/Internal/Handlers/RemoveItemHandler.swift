import Foundation

final class RemoveItemHandler {
	private let offlineStore: OfflineStore

	init(offlineStore: OfflineStore) {
		self.offlineStore = offlineStore
	}

	func handle(_ task: RemoveItemTask) -> InternalTask {
		InternalRemoveItemTask(task: task, offlineStore: offlineStore)
	}
}

private final class InternalRemoveItemTask: InternalTask {
	let id: String

	private let task: RemoveItemTask
	private let offlineStore: OfflineStore

	init(task: RemoveItemTask, offlineStore: OfflineStore) {
		self.id = task.id
		self.task = task
		self.offlineStore = offlineStore
	}

	func run() async throws {
		print("RemoveItemHandler: deleting \(task.resourceType)/\(task.resourceId) from \(task.collectionResourceType)/\(task.collectionResourceId)")
		try offlineStore.deleteMediaItem(
			resourceType: task.resourceType,
			resourceId: task.resourceId,
			fromCollection: task.collectionResourceType,
			collectionId: task.collectionResourceId
		)
	}
}
