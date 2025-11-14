import Foundation

public enum RetryStrategy {
	case BACKOFF(duration: TimeInterval)
	case NONE
}
