import Foundation

final class StoreCollectionHandler {
	private let backendRepository: BackendRepositoryProtocol
	private let localRepository: LocalRepository
	private let artworkDownloader: ArtworkRepositoryProtocol

	init(backendRepository: BackendRepositoryProtocol, localRepository: LocalRepository, artworkDownloader: ArtworkRepositoryProtocol) {
		self.backendRepository = backendRepository
		self.localRepository = localRepository
		self.artworkDownloader = artworkDownloader
	}

	func execute(_ task: StoreCollectionTask) async {
		do {
			try await backendRepository.updateTask(taskId: task.id, state: .inProgress)

			let artworkURL = try await artworkDownloader.downloadArtwork(for: task)
			try localRepository.storeCollection(task: task, artworkURL: artworkURL)

			try await backendRepository.updateTask(taskId: task.id, state: .completed)
		} catch {
			try? await backendRepository.updateTask(taskId: task.id, state: .failed)
		}
	}
}
