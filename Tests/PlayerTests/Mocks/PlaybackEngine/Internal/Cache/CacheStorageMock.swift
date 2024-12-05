import Foundation
@testable import Player

final class CacheStorageMock: CacheStorage {
	func save(_ entry: CacheEntry) throws {}

	func get(key: String) throws -> CacheEntry? {
		nil
	}

	func delete(key: String) throws {}

	func update(_ entry: CacheEntry) throws {}

	func getAll() throws -> [CacheEntry] {
		[]
	}

	func totalSize() throws -> Int {
		0
	}

	func pruneToSize(_ maxSize: Int) throws {}
}
