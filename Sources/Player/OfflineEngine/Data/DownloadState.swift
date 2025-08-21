import Foundation

/// Internal download state tracking for enhanced download management and resilience.
/// This enum tracks the lifecycle state of individual download operations.
enum DownloadState: String, Codable, CaseIterable {
	case PENDING = "PENDING"
	case IN_PROGRESS = "IN_PROGRESS"
	case PAUSED = "PAUSED"
	case FAILED = "FAILED"
	case COMPLETED = "COMPLETED"
	case CANCELLED = "CANCELLED"
}