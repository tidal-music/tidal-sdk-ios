import Foundation

/// Internal download state tracking for enhanced download management and resilience.
/// This enum tracks the lifecycle state of individual download operations.
enum DownloadState: String, Codable, CaseIterable {
	case PENDING
	case IN_PROGRESS
	case PAUSED
	case FAILED
	case COMPLETED
	case CANCELLED
}
