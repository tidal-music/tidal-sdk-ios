import Foundation

public final class TimeoutErrorManager: BaseErrorManager, ErrorManager {
	public init(backoffPolicy: BackoffPolicy = JitteredBackoffPolicy.forTimeoutErrors) {
		super.init(maxRetryAttempts: 3, backoffPolicy: backoffPolicy)
	}

	public func onError(_ error: Error, attemptCount: Int) -> RetryStrategy {
		if error is CancellationError {
			return .NONE
		}

		if attemptCount == maxErrorRetryAttempts {
			return .NONE
		}

		return .BACKOFF(duration: backoffPolicy.onFailedAttempt(attemptCount: attemptCount))
	}
}
