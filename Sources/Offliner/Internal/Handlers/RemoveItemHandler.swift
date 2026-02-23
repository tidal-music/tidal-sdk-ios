import Foundation

final class RemoveItemHandler {
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore

	init(backendClient: BackendClientProtocol, offlineStore: OfflineStore) {
		self.backendClient = backendClient
		self.offlineStore = offlineStore
	}

	func handle(_ task: RemoveItemTask) -> InternalTask {
		InternalTaskImpl(
			task: task,
			backendClient: backendClient,
			offlineStore: offlineStore
		)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String

	private let task: RemoveItemTask
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore

	init(task: RemoveItemTask, backendClient: BackendClientProtocol, offlineStore: OfflineStore) {
		self.id = task.id
		self.task = task
		self.backendClient = backendClient
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
			try await backendClient.updateTask(taskId: id, state: .completed)
		} catch {
			print("RemoveItemHandler error: \(error)")
			try? await backendClient.updateTask(taskId: id, state: .failed)
		}
	}
}
