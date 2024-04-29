import Foundation

final class TimeoutErrorManager: BaseErrorManager, ErrorManager {
	init(backoffPolicy: BackoffPolicy = JitteredBackoffPolicy.forTimeoutErrors) {
		super.init(maxRetryAttempts: 3, backoffPolicy: backoffPolicy)
	}

	func onError(_ error: Error, attemptCount: Int) -> RetryStrategy {
		if error is CancellationError {
			return .NONE
		}

		if attemptCount == maxErrorRetryAttempts {
			return .NONE
		}

		return .BACKOFF(duration: backoffPolicy.onFailedAttempt(attemptCount: attemptCount))
	}
}
