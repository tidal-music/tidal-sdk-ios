import Foundation

/// Protocol defining the interface for managing download state persistence
protocol DownloadStateManager {    
    /// Get a summary of all downloads in the system
    /// - Returns: A summary containing counts and metrics of downloads
    func getDownloadSummary() throws -> DownloadSummary
    /// Create a new download entry to track a download
    /// - Parameters:
    ///   - productId: The product ID for the content being downloaded
    ///   - productType: The type of product (track, video)
    /// - Returns: A new download entry in PENDING state
    func createDownload(productId: String, productType: ProductType) throws -> DownloadEntry
    
    /// Get a download entry by its unique ID
    /// - Parameter id: The unique download ID
    /// - Returns: The download entry or nil if not found
    func getDownload(id: String) throws -> DownloadEntry?
    
    /// Get a download entry by product ID
    /// - Parameter productId: The product ID for the content
    /// - Returns: The download entry or nil if not found
    func getDownloadByProductId(productId: String) throws -> DownloadEntry?
    
    /// Update the state of a download
    /// - Parameters:
    ///   - id: The unique download ID
    ///   - state: The new state to set
    /// - Returns: The updated download entry or nil if not found
    func updateDownloadState(id: String, state: DownloadState) throws -> DownloadEntry?
    
    /// Update the progress of a download
    /// - Parameters:
    ///   - id: The unique download ID
    ///   - progress: The download progress (0.0 - 1.0)
    /// - Returns: The updated download entry or nil if not found
    func updateDownloadProgress(id: String, progress: Double) throws -> DownloadEntry?
    
    /// Record an error for a download
    /// - Parameters:
    ///   - id: The unique download ID
    ///   - error: The error that occurred
    /// - Returns: The updated download entry or nil if not found
    func recordDownloadError(id: String, error: Error) throws -> DownloadEntry?
    
    /// Delete a download entry
    /// - Parameter id: The unique download ID
    func deleteDownload(id: String) throws
    
    /// Get all download entries
    /// - Returns: All download entries
    func getAllDownloads() throws -> [DownloadEntry]
    
    /// Get download entries by state
    /// - Parameter state: The state to filter by
    /// - Returns: Download entries in the specified state
    func getDownloadsByState(state: DownloadState) throws -> [DownloadEntry]
    
    /// Clean up stale downloads (failed/cancelled downloads older than the threshold)
    /// - Parameter threshold: Time threshold in seconds
    /// - Returns: Number of entries deleted
    func cleanupStaleDownloads(threshold: TimeInterval) throws -> Int
    
    /// Get download metrics including success rate and average completion time
    /// - Parameter days: Number of days to include in the calculation (default: 7)
    /// - Returns: Metrics about download performance
    func getDownloadMetrics(days: Int) throws -> DownloadMetrics
}