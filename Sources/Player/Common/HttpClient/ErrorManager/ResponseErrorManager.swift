import Common
import Foundation

final class ResponseErrorManager: BaseErrorManager, ErrorManager {
	init(backoffPolicy: BackoffPolicy = JitteredBackoffPolicy.standard) {
		super.init(maxRetryAttempts: 3, backoffPolicy: backoffPolicy)
	}

	func onError(_ error: Error, attemptCount: Int) -> RetryStrategy {
		// HTTP response with status 4xx (except 429)
		if let httpClientError = error as? HttpError, case let .httpClientError(statusCode, _) = httpClientError,
		   statusCode != 429
		{
			return .NONE
		}

		if let playerInternalError = error as? PlayerInternalError {
			// HTTP response with status != (2xx && 4xx && 5xx)
			if playerInternalError.errorType == .httpClientError, playerInternalError.errorId == .EUnexpected {
				return .NONE
			}
		}

		if attemptCount == maxErrorRetryAttempts {
			return .NONE
		}

		return .BACKOFF(duration: backoffPolicy.onFailedAttempt(attemptCount: attemptCount))
	}
}
