import Foundation
@testable import Player

/// Mock implementation of DownloadStateManager for testing
final class DownloadStateManagerMock: DownloadStateManager {
    // Verification properties
    var createdDownloads: [(productId: String, productType: ProductType)] = []
    var updatedDownloadStates: [(id: String, state: DownloadState)] = []
    var updatedDownloadProgresses: [(id: String, progress: Double)] = []
    var recordedErrors: [(id: String, error: Error)] = []
    var deletedDownloads: [String] = []
    var clearedStaleDownloads: Bool = false
    var cleanupStaleDownloadsCall: (threshold: TimeInterval, deletedCount: Int)?
    
    // Mock behavior configuration
    var mockDownloads: [String: DownloadEntry] = [:]
    var mockDownloadsByProductId: [String: DownloadEntry] = [:]
    var mockDownloadsByState: [DownloadState: [DownloadEntry]] = [:]
    var mockAllDownloads: [DownloadEntry] = []
    
    // Error control
    var errorToThrow: Error?
    var mockDeletedCount: Int = 0
    
    func createDownload(productId: String, productType: ProductType) throws -> DownloadEntry {
        if let error = errorToThrow { throw error }
        
        createdDownloads.append((productId: productId, productType: productType))
        
        // If we have a mock download for this product ID, return it
        if let existingDownload = mockDownloadsByProductId[productId] {
            return existingDownload
        }
        
        // Otherwise create a new one
        let downloadId = UUID().uuidString
        let downloadEntry = DownloadEntry(
            id: downloadId,
            productId: productId,
            productType: productType
        )
        
        mockDownloads[downloadId] = downloadEntry
        mockDownloadsByProductId[productId] = downloadEntry
        mockAllDownloads.append(downloadEntry)
        
        return downloadEntry
    }
    
    func getDownload(id: String) throws -> DownloadEntry? {
        if let error = errorToThrow { throw error }
        return mockDownloads[id]
    }
    
    func getDownloadByProductId(productId: String) throws -> DownloadEntry? {
        if let error = errorToThrow { throw error }
        return mockDownloadsByProductId[productId]
    }
    
    func updateDownloadState(id: String, state: DownloadState) throws -> DownloadEntry? {
        if let error = errorToThrow { throw error }
        
        updatedDownloadStates.append((id: id, state: state))
        
        guard var download = mockDownloads[id] else {
            return nil
        }
        
        download.updateState(state)
        mockDownloads[id] = download
        mockDownloadsByProductId[download.productId] = download
        
        return download
    }
    
    func updateDownloadProgress(id: String, progress: Double) throws -> DownloadEntry? {
        if let error = errorToThrow { throw error }
        
        updatedDownloadProgresses.append((id: id, progress: progress))
        
        guard var download = mockDownloads[id] else {
            return nil
        }
        
        download.updateProgress(progress)
        mockDownloads[id] = download
        mockDownloadsByProductId[download.productId] = download
        
        return download
    }
    
    func recordDownloadError(id: String, error: Error) throws -> DownloadEntry? {
        if let errorToThrow = errorToThrow { throw errorToThrow }
        
        recordedErrors.append((id: id, error: error))
        
        guard var download = mockDownloads[id] else {
            return nil
        }
        
        download.recordError(error)
        download.updateState(.FAILED)
        mockDownloads[id] = download
        mockDownloadsByProductId[download.productId] = download
        
        return download
    }
    
    func deleteDownload(id: String) throws {
        if let error = errorToThrow { throw error }
        
        deletedDownloads.append(id)
        if let download = mockDownloads[id] {
            mockDownloads.removeValue(forKey: id)
            mockDownloadsByProductId.removeValue(forKey: download.productId)
            mockAllDownloads.removeAll { $0.id == id }
        }
    }
    
    func getAllDownloads() throws -> [DownloadEntry] {
        if let error = errorToThrow { throw error }
        return mockAllDownloads
    }
    
    func getDownloadsByState(state: DownloadState) throws -> [DownloadEntry] {
        if let error = errorToThrow { throw error }
        return mockDownloadsByState[state] ?? []
    }
    
    func cleanupStaleDownloads(threshold: TimeInterval) throws -> Int {
        if let error = errorToThrow { throw error }
        clearedStaleDownloads = true
        cleanupStaleDownloadsCall = (threshold: threshold, deletedCount: mockDeletedCount)
        return mockDeletedCount
    }
    
    // MARK: - Reset for testing
    
    func reset() {
        createdDownloads = []
        updatedDownloadStates = []
        updatedDownloadProgresses = []
        recordedErrors = []
        deletedDownloads = []
        clearedStaleDownloads = false
        cleanupStaleDownloadsCall = nil
        
        mockDownloads = [:]
        mockDownloadsByProductId = [:]
        mockDownloadsByState = [:]
        mockAllDownloads = []
        
        errorToThrow = nil
        mockDeletedCount = 0
    }
}