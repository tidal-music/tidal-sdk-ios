import Foundation

/// Download entry for tracking download operations.
/// This provides persistence for download tasks that may be interrupted by network changes, 
/// app termination, or other issues.
struct DownloadEntry: Codable {
    /// Unique identifier for the download operation
    let id: String
    
    /// Product ID of the media being downloaded
    let productId: String
    
    /// Type of the product being downloaded (track, video)
    let productType: ProductType
    
    /// Current state of the download
    var state: DownloadState
    
    /// Download progress from 0.0 to 1.0
    var progress: Double
    
    /// Number of attempted downloads for this entry (for retry logic)
    var attemptCount: Int
    
    /// Last error encountered during download (if any)
    var lastError: String?
    
    /// Timestamp when download was created (milliseconds since epoch)
    let createdAt: UInt64
    
    /// Timestamp when download was last updated (milliseconds since epoch)
    var updatedAt: UInt64
    
    /// Timestamp when download was paused (if paused)
    var pausedAt: UInt64?
    
    /// Background task identifier for URLSession tasks
    var backgroundTaskIdentifier: String?
    
    /// Temporary path to partially downloaded media
    var partialMediaPath: String?
    
    /// Temporary path to partially downloaded license
    var partialLicensePath: String?
    
    /// Initialize a new download entry for tracking a download operation
    init(
        id: String,
        productId: String,
        productType: ProductType,
        createdAt: UInt64 = PlayerWorld.timeProvider.timestamp()
    ) {
        self.id = id
        self.productId = productId
        self.productType = productType
        self.state = .PENDING
        self.progress = 0.0
        self.attemptCount = 0
        self.createdAt = createdAt
        self.updatedAt = createdAt
    }
    
    /// Update state and mark as updated
    mutating func updateState(_ newState: DownloadState) {
        state = newState
        updatedAt = PlayerWorld.timeProvider.timestamp()
        
        if newState == .PAUSED {
            pausedAt = updatedAt
        } else {
            pausedAt = nil
        }
    }
    
    /// Update progress and mark as updated
    mutating func updateProgress(_ newProgress: Double) {
        progress = newProgress
        updatedAt = PlayerWorld.timeProvider.timestamp()
    }
    
    /// Increment attempt count and mark as updated
    mutating func incrementAttemptCount() {
        attemptCount += 1
        updatedAt = PlayerWorld.timeProvider.timestamp()
    }
    
    /// Record error information
    mutating func recordError(_ error: Error) {
        lastError = error.localizedDescription
        updatedAt = PlayerWorld.timeProvider.timestamp()
    }
    
    /// Check if this entry is a stale download that can be cleaned up
    /// Stalled downloads are failed downloads older than the given time interval
    func isStale(threshold: TimeInterval = 60 * 60 * 24) -> Bool {
        if state == .FAILED || state == .CANCELLED {
            let now = PlayerWorld.timeProvider.timestamp()
            let staleTimeMs = UInt64(threshold * 1000)
            return (now - updatedAt) > staleTimeMs
        }
        return false
    }
}
