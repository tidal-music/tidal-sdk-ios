import Foundation

final class RemoveCollectionHandler {
	private let offlineRepository: OfflineRepository

	init(offlineRepository: OfflineRepository) {
		self.offlineRepository = offlineRepository
	}

	func execute(_ task: DownloadTask) async throws {
	}
}
