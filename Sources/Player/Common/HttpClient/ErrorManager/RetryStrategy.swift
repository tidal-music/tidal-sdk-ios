import Foundation

enum RetryStrategy {
	case BACKOFF(duration: TimeInterval)
	case NONE
}
