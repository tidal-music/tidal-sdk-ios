import Foundation

final class StoreCollectionHandler {
	private let backendRepository: BackendRepository
	private let offlineRepository: OfflineRepository

	init(backendRepository: BackendRepository, offlineRepository: OfflineRepository) {
		self.backendRepository = backendRepository
		self.offlineRepository = offlineRepository
	}

	func execute(_ task: StoreCollectionTask) async {
		do {
			try await backendRepository.updateTask(taskId: task.id, state: .inProgress)

			// TODO: Implement store collection logic

			try await backendRepository.updateTask(taskId: task.id, state: .completed)
		} catch {
			try? await backendRepository.updateTask(taskId: task.id, state: .failed)
		}
	}
}
