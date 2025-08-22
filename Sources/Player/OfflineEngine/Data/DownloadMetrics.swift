import Foundation

/// Represents download performance metrics over a specific time period.
/// This is part of Phase 3 of the download resilience improvements.
public struct DownloadMetrics {
    /// The time period in days that these metrics cover
    public let periodDays: Int
    
    /// The total number of downloads attempted
    public let totalDownloads: Int
    
    /// The number of downloads that successfully completed
    public let successfulDownloads: Int
    
    /// The number of downloads that failed
    public let failedDownloads: Int
    
    /// The number of downloads that were cancelled
    public let cancelledDownloads: Int
    
    /// The average time in seconds for downloads to complete
    public let averageCompletionTimeSeconds: Double
    
    /// The success rate as a percentage (0-100%)
    public var successRate: Double {
        if totalDownloads == 0 {
            return 0.0
        }
        return Double(successfulDownloads) / Double(totalDownloads) * 100.0
    }
    
    /// The failure rate as a percentage (0-100%)
    public var failureRate: Double {
        if totalDownloads == 0 {
            return 0.0
        }
        return Double(failedDownloads) / Double(totalDownloads) * 100.0
    }
    
    /// The cancellation rate as a percentage (0-100%)
    public var cancellationRate: Double {
        if totalDownloads == 0 {
            return 0.0
        }
        return Double(cancelledDownloads) / Double(totalDownloads) * 100.0
    }
    
    /// Initialize with raw metrics data
    /// - Parameters:
    ///   - periodDays: Time period in days
    ///   - totalDownloads: Total downloads attempted
    ///   - successfulDownloads: Downloads completed successfully
    ///   - failedDownloads: Downloads that failed
    ///   - cancelledDownloads: Downloads that were cancelled
    ///   - averageCompletionTimeSeconds: Average time in seconds to complete a download
    public init(
        periodDays: Int,
        totalDownloads: Int,
        successfulDownloads: Int,
        failedDownloads: Int,
        cancelledDownloads: Int,
        averageCompletionTimeSeconds: Double
    ) {
        self.periodDays = periodDays
        self.totalDownloads = totalDownloads
        self.successfulDownloads = successfulDownloads
        self.failedDownloads = failedDownloads
        self.cancelledDownloads = cancelledDownloads
        self.averageCompletionTimeSeconds = averageCompletionTimeSeconds
    }
}

/// Extension providing human-readable metrics information
extension DownloadMetrics: CustomStringConvertible {
    public var description: String {
        let successRateFormatted = String(format: "%.1f", successRate)
        let failureRateFormatted = String(format: "%.1f", failureRate)
        let cancellationRateFormatted = String(format: "%.1f", cancellationRate)
        
        // Format completion time in a human-readable way
        let formattedTime: String
        if averageCompletionTimeSeconds < 60 {
            // Less than a minute
            formattedTime = "\(Int(averageCompletionTimeSeconds))s"
        } else if averageCompletionTimeSeconds < 3600 {
            // Less than an hour
            let minutes = Int(averageCompletionTimeSeconds / 60)
            let seconds = Int(averageCompletionTimeSeconds) % 60
            formattedTime = "\(minutes)m \(seconds)s"
        } else {
            // Hours or more
            let hours = Int(averageCompletionTimeSeconds / 3600)
            let minutes = Int(averageCompletionTimeSeconds.truncatingRemainder(dividingBy: 3600) / 60)
            formattedTime = "\(hours)h \(minutes)m"
        }
        
        return """
        Download Metrics (Last \(periodDays) days):
          Total Downloads: \(totalDownloads)
          Success Rate: \(successRateFormatted)%
          Failure Rate: \(failureRateFormatted)%
          Cancellation Rate: \(cancellationRateFormatted)%
          Average Completion Time: \(formattedTime)
        """
    }
}