import Foundation
@testable import Player

final class OfflineStorageMock: OfflineStorage {
    // MARK: - Properties for verification
    
    var savedOfflineEntries: [OfflineEntry] = []
    var savedDownloadEntries: [DownloadEntry] = []
    var deletedProductIds: [String] = []
    var deletedDownloadIds: [String] = []
    var updatedDownloadEntries: [DownloadEntry] = []
    var clearedStorage: Bool = false
    var clearedStaleDownloads: Bool = false
    
    // Custom behavior setup
    var mockOfflineEntries: [String: OfflineEntry] = [:]
    var mockDownloadEntries: [String: DownloadEntry] = [:]
    var mockDownloadEntriesByProductId: [String: DownloadEntry] = [:]
    var mockDownloadEntriesByState: [DownloadState: [DownloadEntry]] = [:]
    var mockAllDownloadEntries: [DownloadEntry] = []
    var mockTotalSize: Int = 0
    
    // Return values for throwing functions
    var errorToThrow: Error?
    
    // MARK: - OfflineEntry Management
    
	func save(_ entry: OfflineEntry) throws {
        if let error = errorToThrow { throw error }
        savedOfflineEntries.append(entry)
        mockOfflineEntries[entry.productId] = entry
    }

	func get(key: String) throws -> OfflineEntry? {
        if let error = errorToThrow { throw error }
        return mockOfflineEntries[key]
    }

	func delete(key: String) throws {
        if let error = errorToThrow { throw error }
        deletedProductIds.append(key)
        mockOfflineEntries.removeValue(forKey: key)
    }

	func getAll() throws -> [OfflineEntry] {
        if let error = errorToThrow { throw error }
        return Array(mockOfflineEntries.values)
    }

	func clear() throws {
        if let error = errorToThrow { throw error }
        clearedStorage = true
        mockOfflineEntries.removeAll()
    }

	func totalSize() throws -> Int {
        if let error = errorToThrow { throw error }
        return mockTotalSize
    }
    
    // MARK: - DownloadEntry Management
    
    func saveDownloadEntry(_ entry: DownloadEntry) throws {
        if let error = errorToThrow { throw error }
        savedDownloadEntries.append(entry)
        mockDownloadEntries[entry.id] = entry
        mockDownloadEntriesByProductId[entry.productId] = entry
    }
    
    func getDownloadEntry(id: String) throws -> DownloadEntry? {
        if let error = errorToThrow { throw error }
        return mockDownloadEntries[id]
    }
    
    func getDownloadEntryByProductId(productId: String) throws -> DownloadEntry? {
        if let error = errorToThrow { throw error }
        return mockDownloadEntriesByProductId[productId]
    }
    
    func getAllDownloadEntries() throws -> [DownloadEntry] {
        if let error = errorToThrow { throw error }
        return mockAllDownloadEntries
    }
    
    func getDownloadEntriesByState(state: DownloadState) throws -> [DownloadEntry] {
        if let error = errorToThrow { throw error }
        return mockDownloadEntriesByState[state] ?? []
    }
    
    func deleteDownloadEntry(id: String) throws {
        if let error = errorToThrow { throw error }
        deletedDownloadIds.append(id)
        mockDownloadEntries.removeValue(forKey: id)
    }
    
    func updateDownloadEntry(_ entry: DownloadEntry) throws {
        if let error = errorToThrow { throw error }
        updatedDownloadEntries.append(entry)
        mockDownloadEntries[entry.id] = entry
        mockDownloadEntriesByProductId[entry.productId] = entry
    }
    
    func cleanupStaleDownloadEntries(threshold: TimeInterval) throws {
        if let error = errorToThrow { throw error }
        clearedStaleDownloads = true
    }
    
    // MARK: - Reset for testing
    
    func reset() {
        savedOfflineEntries = []
        savedDownloadEntries = []
        deletedProductIds = []
        deletedDownloadIds = []
        updatedDownloadEntries = []
        clearedStorage = false
        clearedStaleDownloads = false
        
        mockOfflineEntries = [:]
        mockDownloadEntries = [:]
        mockDownloadEntriesByProductId = [:]
        mockDownloadEntriesByState = [:]
        mockAllDownloadEntries = []
        mockTotalSize = 0
        
        errorToThrow = nil
    }
}
