import Common
import Foundation

// MARK: - TidalAPINetworkErrorManager

final class TidalAPINetworkErrorManager: BaseErrorManager, ErrorManager {
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

// MARK: - TidalAPITimeoutErrorManager

final class TidalAPITimeoutErrorManager: BaseErrorManager, ErrorManager {
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

// MARK: - TidalAPIResponseErrorManager

final class TidalAPIResponseErrorManager: BaseErrorManager, ErrorManager {
	init(backoffPolicy: BackoffPolicy = JitteredBackoffPolicy.standard) {
		super.init(maxRetryAttempts: 3, backoffPolicy: backoffPolicy)
	}

	func onError(_ error: Error, attemptCount: Int) -> RetryStrategy {
		// HTTPErrorResponse handling (retry handler already filtered to 5xx/429)
		// Legacy ErrorResponse handling for backward compatibility
		if let errorResponse = error as? ErrorResponse,
		   case let .error(statusCode, _, _, _) = errorResponse,
		   statusCode >= 400 && statusCode < 500 && statusCode != 429
		{
			return .NONE
		}

		if attemptCount == maxErrorRetryAttempts {
			return .NONE
		}

		return .BACKOFF(duration: backoffPolicy.onFailedAttempt(attemptCount: attemptCount))
	}
}
