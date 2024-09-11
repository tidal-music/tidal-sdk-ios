import Foundation

protocol OfflineStorage {
	func save(_ entry: OfflineEntry) throws
	func get(mediaProduct: MediaProduct) throws -> OfflineEntry?
	func delete(mediaProduct: MediaProduct) throws
	func getAll() throws -> [OfflineEntry]
	func clear() throws
	func totalSize() throws -> Int
}
