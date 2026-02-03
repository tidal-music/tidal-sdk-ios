import Foundation

final class RemoveItemHandler {
	private let backendRepository: BackendRepositoryProtocol
	private let localRepository: LocalRepository

	init(backendRepository: BackendRepositoryProtocol, localRepository: LocalRepository) {
		self.backendRepository = backendRepository
		self.localRepository = localRepository
	}

	func execute(_ task: RemoveItemTask) async {
	}
}
