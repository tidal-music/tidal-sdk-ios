import Foundation

final class RemoveCollectionHandler {
	private let backendRepository: BackendRepository
	private let offlineRepository: OfflineRepository

	init(backendRepository: BackendRepository, offlineRepository: OfflineRepository) {
		self.backendRepository = backendRepository
		self.offlineRepository = offlineRepository
	}

	func execute(_ task: RemoveCollectionTask) async {
		do {
			try await backendRepository.updateTask(taskId: task.id, state: .inProgress)

			// TODO: Implement remove collection logic

			try await backendRepository.updateTask(taskId: task.id, state: .completed)
		} catch {
			try? await backendRepository.updateTask(taskId: task.id, state: .failed)
		}
	}
}
