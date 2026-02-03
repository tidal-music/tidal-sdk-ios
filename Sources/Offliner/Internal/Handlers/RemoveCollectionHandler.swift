import Foundation

final class RemoveCollectionHandler {
	private let backendRepository: BackendRepository
	private let localRepository: LocalRepository

	init(backendRepository: BackendRepository, localRepository: LocalRepository) {
		self.backendRepository = backendRepository
		self.localRepository = localRepository
	}

	func execute(_ task: RemoveCollectionTask) async {
	}
}
