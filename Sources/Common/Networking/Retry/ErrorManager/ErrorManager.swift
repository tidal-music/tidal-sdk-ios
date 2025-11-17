import Foundation

/// Describes the retry strategy to use when there is an error
public protocol ErrorManager: AnyObject {
	/// Implementations should return a RetryStrategy to indicate how the connection should be retried
	///
	/// - Parameters:
	///   - error: The error that we need to manage.
	///   - attempt: The attempt count.
	/// - Returns: A RetryStrategy value indicating how should a retry be attempted.
	func onError(_ error: Error, attemptCount: Int) -> RetryStrategy
}
