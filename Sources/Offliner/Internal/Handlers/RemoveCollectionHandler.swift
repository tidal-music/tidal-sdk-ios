import Foundation

final class RemoveCollectionHandler {
	private let offlineStore: OfflineStore

	init(offlineStore: OfflineStore) {
		self.offlineStore = offlineStore
	}

	func handle(_ task: RemoveCollectionTask) -> InternalTask {
		InternalRemoveCollectionTask(task: task, offlineStore: offlineStore)
	}
}

private final class InternalRemoveCollectionTask: InternalTask {
	let id: String
	let removedCollectionScope: CollectionTaskScope?

	private let task: RemoveCollectionTask
	private let offlineStore: OfflineStore

	init(task: RemoveCollectionTask, offlineStore: OfflineStore) {
		self.id = task.id
		self.task = task
		removedCollectionScope = CollectionTaskScope(
			resourceType: task.resourceType,
			resourceId: task.resolvedResourceId
		)
		self.offlineStore = offlineStore
	}

	func run() async throws {
		try offlineStore.deleteCollection(resourceType: task.resourceType, resourceId: task.resolvedResourceId)
	}
}

private extension RemoveCollectionTask {
	var resolvedResourceId: String {
		resourceType == OfflineCollectionType.userCollectionTracks.rawValue ? ResourceId.me.stringValue : resourceId
	}
}
