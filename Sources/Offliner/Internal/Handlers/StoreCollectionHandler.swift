import Foundation

final class StoreCollectionHandler {
	private let backendRepository: BackendRepository
	private let localRepository: LocalRepository
	private let artworkRepository: ArtworkRepository

	init(backendRepository: BackendRepository, localRepository: LocalRepository, artworkRepository: ArtworkRepository) {
		self.backendRepository = backendRepository
		self.localRepository = localRepository
		self.artworkRepository = artworkRepository
	}

	func execute(_ task: StoreCollectionTask) async {
		do {
			try await backendRepository.updateTask(taskId: task.id, state: .inProgress)

			let artworkURL = try await artworkRepository.downloadArtwork(for: task)
			try localRepository.storeCollection(task: task, artworkURL: artworkURL)

			try await backendRepository.updateTask(taskId: task.id, state: .completed)
		} catch {
			try? await backendRepository.updateTask(taskId: task.id, state: .failed)
		}
	}
}
