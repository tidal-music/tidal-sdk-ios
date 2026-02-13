import Foundation

final class RemoveItemHandler {
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore

	init(backendClient: BackendClientProtocol, offlineStore: OfflineStore) {
		self.backendClient = backendClient
		self.offlineStore = offlineStore
	}

	func handle(_ task: RemoveItemTask) async -> InternalTask? {
		InternalTaskImpl(
			task: task,
			backendClient: backendClient,
			offlineStore: offlineStore
		)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String

	private let metadata: OfflineMediaItem.Metadata
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore

	init(task: RemoveItemTask, backendClient: BackendClientProtocol, offlineStore: OfflineStore) {
		self.id = task.id
		self.metadata = task.metadata
		self.backendClient = backendClient
		self.offlineStore = offlineStore
	}

	func run() async {
		do {
			try offlineStore.deleteItem(
				resourceType: metadata.resourceType,
				resourceId: metadata.resourceId
			)
			try await backendClient.updateTask(taskId: id, state: .completed)
		} catch {
			print("RemoveItemHandler error: \(error)")
			try? await backendClient.updateTask(taskId: id, state: .failed)
		}
	}
}
