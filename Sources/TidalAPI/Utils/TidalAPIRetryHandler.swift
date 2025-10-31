import Common
import Foundation

typealias RequestBuilderExecutor<T> = () async throws -> T

// MARK: - TidalAPIRetryHandler

final class TidalAPIRetryHandler<T> {
	private let executionBlock: RequestBuilderExecutor<T>
	private let responseErrorManager: ErrorManager
	private let networkErrorManager: ErrorManager
	private let timeoutErrorManager: ErrorManager

	init(
		executionBlock: @escaping RequestBuilderExecutor<T>,
		responseErrorManager: ErrorManager = TidalAPIResponseErrorManager(),
		networkErrorManager: ErrorManager = TidalAPINetworkErrorManager(),
		timeoutErrorManager: ErrorManager = TidalAPITimeoutErrorManager()
	) {
		self.executionBlock = executionBlock
		self.responseErrorManager = responseErrorManager
		self.networkErrorManager = networkErrorManager
		self.timeoutErrorManager = timeoutErrorManager
	}

	func execute(attemptCount: Int = 0) async throws -> T {
		do {
			return try await executionBlock()
		} catch {
			try Task.checkCancellation()

			// Determine which error manager to use (same logic as Player's ResponseHandler)
			let retryStrategy: RetryStrategy = if isTimeoutError(error) {
				timeoutErrorManager.onError(error, attemptCount: attemptCount)
			} else if isNetworkError(error) {
				networkErrorManager.onError(error, attemptCount: attemptCount)
			} else {
				responseErrorManager.onError(error, attemptCount: attemptCount)
			}

			switch retryStrategy {
			case .NONE:
				throw error
			case let .BACKOFF(duration):
				try await Task.sleep(seconds: duration)
				return try await execute(attemptCount: attemptCount + 1)
			}
		}
	}

	private func isTimeoutError(_ error: Error) -> Bool {
		// Check if it's a URLError with timeout
		if let urlError = error as? URLError {
			return urlError.code == .timedOut
		}

		return false
	}

	private func isNetworkError(_ error: Error) -> Bool {
		// Check if it's a URLError indicating network issues
		if let urlError = error as? URLError {
			switch urlError.code {
			case .networkConnectionLost, .notConnectedToInternet,
			     .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
				return true
			default:
				return false
			}
		}

		// Check if it's an ErrorResponse with network-related status codes
		if let errorResponse = error as? ErrorResponse,
		   case let .error(statusCode, _, _, _) = errorResponse
		{
			// Status codes -1 and -2 are network errors from the generated client
			return statusCode == -1 || statusCode == -2
		}

		return false
	}
}
