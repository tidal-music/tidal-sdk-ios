import Foundation

protocol OfflineStorage {
	// MARK: - OfflineEntry Management (Completed downloads)
	
	/// Save a completed offline entry
	func save(_ entry: OfflineEntry) throws
	
	/// Get an offline entry by product ID
	func get(key: String) throws -> OfflineEntry?
	
	/// Delete an offline entry by product ID
	func delete(key: String) throws
	
	/// Get all offline entries
	func getAll() throws -> [OfflineEntry]
	
	/// Clear all offline entries
	func clear() throws
	
	/// Get total size of all offline entries
	func totalSize() throws -> Int
	
	// MARK: - DownloadEntry Management (In-progress downloads)
	
	/// Save a download entry for tracking an in-progress download
	func saveDownloadEntry(_ entry: DownloadEntry) throws
	
	/// Get a download entry by its unique ID
	func getDownloadEntry(id: String) throws -> DownloadEntry?
	
	/// Get a download entry by product ID (if one exists)
	func getDownloadEntryByProductId(productId: String) throws -> DownloadEntry?
	
	/// Get all download entries
	func getAllDownloadEntries() throws -> [DownloadEntry]
	
	/// Get download entries by state
	func getDownloadEntriesByState(state: DownloadState) throws -> [DownloadEntry]
	
	/// Delete a download entry by ID
	func deleteDownloadEntry(id: String) throws
	
	/// Update an existing download entry
	func updateDownloadEntry(_ entry: DownloadEntry) throws
	
	/// Clean up old failed or cancelled downloads older than the specified threshold
	/// - Parameter threshold: Time interval in seconds to determine which entries are stale
	/// - Returns: Number of entries deleted
	func cleanupStaleDownloadEntries(threshold: TimeInterval) throws -> Int
}
