import Foundation

final class RemoveItemHandler {
	private let backendRepository: BackendRepository
	private let offlineRepository: OfflineRepository

	init(backendRepository: BackendRepository, offlineRepository: OfflineRepository) {
		self.backendRepository = backendRepository
		self.offlineRepository = offlineRepository
	}

	func execute(_ task: RemoveItemTask) async {
		do {
			try await backendRepository.updateTask(taskId: task.id, state: .inProgress)

			// TODO: Implement remove item logic

			try await backendRepository.updateTask(taskId: task.id, state: .completed)
		} catch {
			try? await backendRepository.updateTask(taskId: task.id, state: .failed)
		}
	}
}
