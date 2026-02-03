import Foundation

final class RemoveItemHandler {
	private let backendRepository: BackendRepository
	private let localRepository: LocalRepository

	init(backendRepository: BackendRepository, localRepository: LocalRepository) {
		self.backendRepository = backendRepository
		self.localRepository = localRepository
	}

	func execute(_ task: RemoveItemTask) async {
	}
}
