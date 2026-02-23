import Foundation

final class RemoveCollectionHandler {
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore

	init(backendClient: BackendClientProtocol, offlineStore: OfflineStore) {
		self.backendClient = backendClient
		self.offlineStore = offlineStore
	}

	func handle(_ task: RemoveCollectionTask) -> InternalTask {
		InternalTaskImpl(
			task: task,
			backendClient: backendClient,
			offlineStore: offlineStore
		)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String

	private let task: RemoveCollectionTask
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore

	init(task: RemoveCollectionTask, backendClient: BackendClientProtocol, offlineStore: OfflineStore) {
		self.id = task.id
		self.task = task
		self.backendClient = backendClient
		self.offlineStore = offlineStore
	}

	func run() async {
		print("RemoveCollectionHandler: deleting \(task.resourceType)/\(task.resourceId)")
		do {
			try offlineStore.deleteCollection(resourceType: task.resourceType, resourceId: task.resourceId)
			try await backendClient.updateTask(taskId: id, state: .completed)
		} catch {
			print("RemoveCollectionHandler error: \(error)")
			try? await backendClient.updateTask(taskId: id, state: .failed)
		}
	}
}
