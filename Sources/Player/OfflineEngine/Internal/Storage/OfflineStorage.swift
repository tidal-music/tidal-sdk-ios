import Foundation

protocol OfflineStorage {
	func save(_ entry: OfflineEntry) throws
	func get(key: String) throws -> OfflineEntry?
	func delete(key: String) throws
	func getAll() throws -> [OfflineEntry]
	func clear() throws
	func totalSize() throws -> Int
}
