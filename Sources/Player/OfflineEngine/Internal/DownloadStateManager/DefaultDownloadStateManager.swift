import Foundation

/// Default implementation of the DownloadStateManager protocol using OfflineStorage for persistence
final class DefaultDownloadStateManager: DownloadStateManager {
    private let offlineStorage: OfflineStorage
    
    init(offlineStorage: OfflineStorage) {
        self.offlineStorage = offlineStorage
    }
    
    func createDownload(productId: String, productType: ProductType) throws -> DownloadEntry {
        // Check if there's already a download entry for this product
        if let existingDownload = try getDownloadByProductId(productId: productId) {
            // If download exists but is in FAILED or CANCELLED state, we can reuse it
            if existingDownload.state == .FAILED || existingDownload.state == .CANCELLED {
                var updatedDownload = existingDownload
                updatedDownload.updateState(.PENDING)
                updatedDownload.updateProgress(0.0)
                try offlineStorage.updateDownloadEntry(updatedDownload)
                return updatedDownload
            }
            
            // Otherwise return the existing download
            return existingDownload
        }
        
        // Create a new download entry
        let downloadId = generateDownloadId()
        let downloadEntry = DownloadEntry(
            id: downloadId,
            productId: productId,
            productType: productType
        )
        
        try offlineStorage.saveDownloadEntry(downloadEntry)
        return downloadEntry
    }
    
    func getDownload(id: String) throws -> DownloadEntry? {
        return try offlineStorage.getDownloadEntry(id: id)
    }
    
    func getDownloadByProductId(productId: String) throws -> DownloadEntry? {
        return try offlineStorage.getDownloadEntryByProductId(productId: productId)
    }
    
    func updateDownloadState(id: String, state: DownloadState) throws -> DownloadEntry? {
        guard var download = try getDownload(id: id) else {
            return nil
        }
        
        download.updateState(state)
        try offlineStorage.updateDownloadEntry(download)
        return download
    }
    
    func updateDownloadProgress(id: String, progress: Double) throws -> DownloadEntry? {
        guard var download = try getDownload(id: id) else {
            return nil
        }
        
        download.updateProgress(progress)
        try offlineStorage.updateDownloadEntry(download)
        return download
    }
    
    func recordDownloadError(id: String, error: Error) throws -> DownloadEntry? {
        guard var download = try getDownload(id: id) else {
            return nil
        }
        
        download.recordError(error)
        download.updateState(.FAILED)
        try offlineStorage.updateDownloadEntry(download)
        return download
    }
    
    func deleteDownload(id: String) throws {
        try offlineStorage.deleteDownloadEntry(id: id)
    }
    
    func getAllDownloads() throws -> [DownloadEntry] {
        return try offlineStorage.getAllDownloadEntries()
    }
    
    func getDownloadsByState(state: DownloadState) throws -> [DownloadEntry] {
        return try offlineStorage.getDownloadEntriesByState(state: state)
    }
    
    func cleanupStaleDownloads(threshold: TimeInterval) throws -> Int {
        return try offlineStorage.cleanupStaleDownloadEntries(threshold: threshold)
    }
    
    func getDownloadSummary() throws -> DownloadSummary {
        let entries = try getAllDownloads()
        return DownloadSummary(entries: entries)
    }
    
    func getDownloadMetrics(days: Int) throws -> DownloadMetrics {
        // Get all downloads from the past N days
        let allDownloads = try getAllDownloads()
        
        // Calculate the timestamp for N days ago
        let now = PlayerWorld.timeProvider.timestamp()
        let millisecondsPerDay: UInt64 = 24 * 60 * 60 * 1000
        let cutoffTimestamp = now - (UInt64(days) * millisecondsPerDay)
        
        // Filter for downloads created within the period
        let recentDownloads = allDownloads.filter { $0.createdAt >= cutoffTimestamp }
        
        // Count downloads by final state
        let successfulDownloads = recentDownloads.filter { $0.state == .COMPLETED }.count
        let failedDownloads = recentDownloads.filter { $0.state == .FAILED }.count
        let cancelledDownloads = recentDownloads.filter { $0.state == .CANCELLED }.count
        
        // Calculate average completion time for successful downloads
        let completedDownloads = recentDownloads.filter { $0.state == .COMPLETED }
        var totalCompletionTime: Double = 0
        
        for download in completedDownloads {
            // Calculate time difference in seconds
            let startTime = Double(download.createdAt) / 1000.0
            let endTime = Double(download.updatedAt) / 1000.0
            totalCompletionTime += (endTime - startTime)
        }
        
        let averageCompletionTime = completedDownloads.isEmpty ? 
            0.0 : totalCompletionTime / Double(completedDownloads.count)
        
        return DownloadMetrics(
            periodDays: days,
            totalDownloads: recentDownloads.count,
            successfulDownloads: successfulDownloads,
            failedDownloads: failedDownloads,
            cancelledDownloads: cancelledDownloads,
            averageCompletionTimeSeconds: averageCompletionTime
        )
    }
    
    // MARK: - Private Helpers
    
    private func generateDownloadId() -> String {
        return UUID().uuidString
    }
}