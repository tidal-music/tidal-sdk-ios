import Foundation

final class StoreCollectionHandler {
	private let offlineRepository: OfflineRepository

	init(offlineRepository: OfflineRepository) {
		self.offlineRepository = offlineRepository
	}

	func execute(_ task: DownloadTask) async throws {
	}
}
