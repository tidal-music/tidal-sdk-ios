import Foundation

final class NetworkErrorManager: BaseErrorManager, ErrorManager {
	init(backoffPolicy: BackoffPolicy = JitteredBackoffPolicy.forNetworkErrors) {
		super.init(maxRetryAttempts: 10, backoffPolicy: backoffPolicy)
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
