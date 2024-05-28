import Foundation

/// Describes how to act when a http request fails due to retryable error.
protocol BackoffPolicy {
	/// Implementations should return a delay to wait until the next attempt is performed.
	/// - Important: Implementations should make sure that the value returned is strictly larger than 0. Doing otherwise may result
	/// in
	/// unpredictable behavior and is not supported.
	/// - Parameters:
	///   - attemptCount: Number of times it was attempted the request.
	/// - Returns: An amount of time to wait until the next attempt is performed, in seconds.
	func onFailedAttempt(attemptCount: Int) -> TimeInterval
}
