import Foundation

final class WebSocketErrorManager: BaseErrorManager, ErrorManager {
	init(backoffPolicy: BackoffPolicy = JitteredBackoffPolicy.webSocketBackoffPolicy) {
		super.init(maxRetryAttempts: 6, backoffPolicy: backoffPolicy)
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
