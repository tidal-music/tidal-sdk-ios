import Auth
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

// MARK: - TidalAPIAuthenticationErrorManager

final class TidalAPIAuthenticationErrorManager: BaseErrorManager {
	init() {
		super.init(maxRetryAttempts: 1, backoffPolicy: StandardBackoffPolicy.standard)
	}

	func handleAuthenticationError(_ error: HTTPErrorResponse, attemptCount: Int) async -> RetryStrategy {
		guard error.statusCode == 401 else {
			return .NONE
		}

		if attemptCount >= maxErrorRetryAttempts {
			return .NONE
		}

		guard let credentialsProvider = OpenAPIClientAPI.credentialsProvider else {
			return .NONE
		}

		let subStatus = extractSubStatus(from: error.data)

		do {
			_ = try await credentialsProvider.getCredentials(apiErrorSubStatus: subStatus.flatMap(String.init))

			if subStatus != nil, !credentialsProvider.isUserLoggedIn {
				return .NONE
			}

			return .BACKOFF(duration: 0)
		} catch {
			return .NONE
		}
	}

	private func extractSubStatus(from data: Data?) -> Int? {
		guard let data else {
			return nil
		}

		do {
			if let parsedObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
			   let subStatus = parsedObject["subStatus"] as? Int
			{
				return subStatus
			}
		} catch {
			return nil
		}
		return nil
	}
}
