import Foundation

/// Represents a summary of download state information,
/// providing aggregated metrics about all downloads in the system.
/// This is part of Phase 3 of the download resilience improvements.
public struct DownloadSummary {
    /// Total number of downloads in all states
    public let totalDownloads: Int
    
    /// Total number of pending downloads
    public let pendingDownloads: Int
    
    /// Total number of in-progress downloads
    public let inProgressDownloads: Int
    
    /// Total number of paused downloads
    public let pausedDownloads: Int
    
    /// Total number of failed downloads
    public let failedDownloads: Int
    
    /// Total number of completed downloads
    public let completedDownloads: Int
    
    /// Total number of cancelled downloads
    public let cancelledDownloads: Int
    
    /// Average progress across all in-progress downloads (0.0 - 1.0)
    public let averageProgress: Double
    
    /// Initialize with individual counts
    /// - Parameters:
    ///   - totalDownloads: Total download count
    ///   - pendingDownloads: Pending download count
    ///   - inProgressDownloads: In-progress download count
    ///   - pausedDownloads: Paused download count
    ///   - failedDownloads: Failed download count
    ///   - completedDownloads: Completed download count
    ///   - cancelledDownloads: Cancelled download count
    ///   - averageProgress: Average progress of in-progress downloads
    public init(
        totalDownloads: Int,
        pendingDownloads: Int,
        inProgressDownloads: Int,
        pausedDownloads: Int,
        failedDownloads: Int,
        completedDownloads: Int,
        cancelledDownloads: Int,
        averageProgress: Double
    ) {
        self.totalDownloads = totalDownloads
        self.pendingDownloads = pendingDownloads
        self.inProgressDownloads = inProgressDownloads
        self.pausedDownloads = pausedDownloads
        self.failedDownloads = failedDownloads
        self.completedDownloads = completedDownloads
        self.cancelledDownloads = cancelledDownloads
        self.averageProgress = averageProgress
    }
    
    /// Initialize from a collection of download entries
    /// - Parameter entries: All download entries to summarize
    init(entries: [DownloadEntry]) {
        var pending = 0
        var inProgress = 0
        var paused = 0
        var failed = 0
        var completed = 0
        var cancelled = 0
        
        var progressSum = 0.0
        var progressCount = 0
        
        for entry in entries {
            switch entry.state {
            case .PENDING:
                pending += 1
            case .IN_PROGRESS:
                inProgress += 1
                progressSum += entry.progress
                progressCount += 1
            case .PAUSED:
                paused += 1
            case .FAILED:
                failed += 1
            case .COMPLETED:
                completed += 1
            case .CANCELLED:
                cancelled += 1
            }
        }
        
        self.totalDownloads = entries.count
        self.pendingDownloads = pending
        self.inProgressDownloads = inProgress
        self.pausedDownloads = paused
        self.failedDownloads = failed
        self.completedDownloads = completed
        self.cancelledDownloads = cancelled
        
        // Calculate average progress (avoid division by zero)
        self.averageProgress = progressCount > 0 ? (progressSum / Double(progressCount)) : 0.0
    }
}

/// Extension providing user-friendly display of download progress
extension DownloadSummary: CustomStringConvertible {
    public var description: String {
        """
        Downloads:
          Total: \(totalDownloads)
          Pending: \(pendingDownloads)
          In Progress: \(inProgressDownloads) (Avg: \(Int(averageProgress * 100))%)
          Paused: \(pausedDownloads)
          Failed: \(failedDownloads)
          Completed: \(completedDownloads)
          Cancelled: \(cancelledDownloads)
        """
    }
}

/// Extension providing a user-friendly display of download progress for UI
extension DownloadSummary {
    /// Get a human-readable string representation of the overall download progress
    /// - Returns: A string suitable for display in a user interface
    public func displayableDownloadProgress() -> String {
        // Format progress as percentage
        let progressPercent = Int(averageProgress * 100)
        
        if inProgressDownloads == 0 {
            return "No active downloads"
        } else if inProgressDownloads == 1 {
            return "Downloading: \(progressPercent)%"
        } else {
            return "Downloading \(inProgressDownloads) items: \(progressPercent)%"
        }
    }
}