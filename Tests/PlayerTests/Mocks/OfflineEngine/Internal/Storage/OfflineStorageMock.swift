import Foundation
@testable import Player

final class OfflineStorageMock: OfflineStorage {
	func save(_ entry: OfflineEntry) throws {}

	func get(key: String) -> OfflineEntry? {
		nil
	}

	func delete(key: String) {}

	func getAll() throws -> [OfflineEntry] { [] }

	func clear() {}
	
	func totalSize() throws -> Int { 
		0
	}
}
