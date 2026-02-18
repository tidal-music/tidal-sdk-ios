import Foundation

final class RemoveHandler {
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore

	init(backendClient: BackendClientProtocol, offlineStore: OfflineStore) {
		self.backendClient = backendClient
		self.offlineStore = offlineStore
	}

	func handle(_ task: RemoveTask) -> InternalTask {
		InternalTaskImpl(
			task: task,
			backendClient: backendClient,
			offlineStore: offlineStore
		)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String

	private let resourceType: String
	private let resourceId: String
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore

	init(task: RemoveTask, backendClient: BackendClientProtocol, offlineStore: OfflineStore) {
		self.id = task.id
		self.resourceType = task.resourceType
		self.resourceId = task.resourceId
		self.backendClient = backendClient
		self.offlineStore = offlineStore
	}

	func run() async {
		print("RemoveHandler: deleting \(resourceType)/\(resourceId)")
		do {
			try offlineStore.deleteItem(
				resourceType: resourceType,
				resourceId: resourceId
			)
			try await backendClient.updateTask(taskId: id, state: .completed)
		} catch {
			print("RemoveHandler error: \(error)")
			try? await backendClient.updateTask(taskId: id, state: .failed)
		}
	}
}
