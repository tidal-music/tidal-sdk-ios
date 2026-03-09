import Foundation

final class RemoveItemHandler {
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore

	init(offlineApiClient: OfflineApiClientProtocol, offlineStore: OfflineStore) {
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
	}

	func handle(_ task: RemoveItemTask) -> InternalTask {
		InternalRemoveItemTask(
			task: task,
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore
		)
	}
}

private final class InternalRemoveItemTask: InternalTask {
	let id: String

	private let task: RemoveItemTask
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore

	init(task: RemoveItemTask, offlineApiClient: OfflineApiClientProtocol, offlineStore: OfflineStore) {
		self.id = task.id
		self.task = task
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
	}

	func run() async {
		print("RemoveItemHandler: deleting \(task.resourceType)/\(task.resourceId) from \(task.collectionResourceType)/\(task.collectionResourceId)")
		do {
			try offlineStore.deleteMediaItem(
				resourceType: task.resourceType,
				resourceId: task.resourceId,
				fromCollection: task.collectionResourceType,
				collectionId: task.collectionResourceId
			)
			try await offlineApiClient.updateTask(taskId: id, state: .completed)
		} catch {
			print("RemoveItemHandler error: \(error)")
			try? await offlineApiClient.updateTask(taskId: id, state: .failed)
		}
	}
}
