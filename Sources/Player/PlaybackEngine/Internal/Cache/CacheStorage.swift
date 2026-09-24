import Foundation

// MARK: - CacheStorage

protocol CacheStorage {
	// MARK: - Save CacheEntry

	func save(_ entry: CacheEntry) throws

	// MARK: - Get CacheEntry by Key

	func get(key: String) throws -> CacheEntry?

	// MARK: - Delete CacheEntry by Key

	func delete(key: String) throws

	// MARK: - Update CacheEntry

	func update(_ entry: CacheEntry) throws

	// MARK: - Get All CacheEntries

	func getAll() throws -> [CacheEntry]

	func getAllOrderedByLastAccessed() throws -> [CacheEntry]

	// MARK: - Calculate Total Size

	func totalSize() throws -> Int

	// MARK: - Prune to a Maximum Size

	func pruneToSize(_ maxSize: Int) throws
}

extension CacheStorage {
	func getAllOrderedByLastAccessed() throws -> [CacheEntry] {
		try getAll().sorted { $0.lastAccessedAt < $1.lastAccessedAt }
	}
}
