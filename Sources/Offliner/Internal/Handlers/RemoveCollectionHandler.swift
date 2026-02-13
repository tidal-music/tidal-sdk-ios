import Foundation

final class RemoveCollectionHandler {
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore

	init(backendClient: BackendClientProtocol, offlineStore: OfflineStore) {
		self.backendClient = backendClient
		self.offlineStore = offlineStore
	}

	func handle(_ task: RemoveCollectionTask) async -> InternalTask? {
		InternalTaskImpl(task: task)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String

	init(task: RemoveCollectionTask) {
		self.id = task.id
	}

	func run() async {
	}
}
