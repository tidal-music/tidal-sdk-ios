import Foundation

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
}
