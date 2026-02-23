import Foundation

final class RemoveCollectionHandler {
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore

	init(offlineApiClient: OfflineApiClientProtocol, offlineStore: OfflineStore) {
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
	}

	func handle(_ task: RemoveCollectionTask) -> InternalTask {
		InternalTaskImpl(
			task: task,
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore
		)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String

	private let task: RemoveCollectionTask
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore

	init(task: RemoveCollectionTask, offlineApiClient: OfflineApiClientProtocol, offlineStore: OfflineStore) {
		self.id = task.id
		self.task = task
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
	}

	func run() async {
		print("RemoveCollectionHandler: deleting \(task.resourceType)/\(task.resourceId)")
		do {
			try offlineStore.deleteCollection(resourceType: task.resourceType, resourceId: task.resourceId)
			try await offlineApiClient.updateTask(taskId: id, state: .completed)
		} catch {
			print("RemoveCollectionHandler error: \(error)")
			try? await offlineApiClient.updateTask(taskId: id, state: .failed)
		}
	}
}
