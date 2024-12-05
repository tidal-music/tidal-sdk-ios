import Foundation

public protocol CacheStorage {
	// MARK: - Save CacheEntry

	func save(_ entry: CacheEntry) throws

	// MARK: - Get CacheEntry by Key

	func get(key: String) throws -> CacheEntry?

	// MARK: - Delete CacheEntry by Key

	func delete(key: String) throws

	// MARK: - Delete All CacheEntries

	func deleteAll() throws

	// MARK: - Update CacheEntry

	func update(_ entry: CacheEntry) throws

	// MARK: - Get All CacheEntries

	func getAll() throws -> [CacheEntry]

	// MARK: - Calculate Total Size

	func totalSize() throws -> Int

	// MARK: - Prune to a Maximum Size

	func pruneToSize(_ maxSize: Int) throws
}
