import Foundation

final class RemoveItemHandler {
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore

	init(backendClient: BackendClientProtocol, offlineStore: OfflineStore) {
		self.backendClient = backendClient
		self.offlineStore = offlineStore
	}

	func handle(_ task: RemoveItemTask) async -> InternalTask? {
		InternalTaskImpl(task: task)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String

	init(task: RemoveItemTask) {
		self.id = task.id
	}

	func run() async {
	}
}
