import Auth
import Common
import Foundation

typealias RequestBuilderExecutor<T> = () async throws -> T

// MARK: - TidalAPIRetryHandler

final class TidalAPIRetryHandler<T> {
	private let executionBlock: RequestBuilderExecutor<T>
	private let responseErrorManager: ErrorManager
	private let networkErrorManager: ErrorManager
	private let timeoutErrorManager: ErrorManager
	private let authenticationErrorManager: ErrorManager

	init(
		executionBlock: @escaping RequestBuilderExecutor<T>,
		responseErrorManager: ErrorManager = TidalAPIResponseErrorManager(),
		networkErrorManager: ErrorManager = TidalAPINetworkErrorManager(),
		timeoutErrorManager: ErrorManager = TidalAPITimeoutErrorManager(),
		authenticationErrorManager: ErrorManager = TidalAPIAuthenticationErrorManager()
	) {
		self.executionBlock = executionBlock
		self.responseErrorManager = responseErrorManager
		self.networkErrorManager = networkErrorManager
		self.timeoutErrorManager = timeoutErrorManager
		self.authenticationErrorManager = authenticationErrorManager
	}

	func execute(attemptCount: Int = 0) async throws -> T {
		do {
			return try await executionBlock()
		} catch let httpError as HTTPErrorResponse {
			try Task.checkCancellation()

			if httpError.statusCode == 401 {
				guard let authManager = authenticationErrorManager as? TidalAPIAuthenticationErrorManager else {
					throw httpError
				}

				let retryStrategy = await authManager.handleAuthenticationError(httpError, attemptCount: attemptCount)

				switch retryStrategy {
				case .NONE:
					throw httpError
				case .BACKOFF:
					return try await execute(attemptCount: attemptCount + 1)
				}
			}

			let retryStrategy: RetryStrategy
			if httpError.statusCode >= 500 || httpError.statusCode == 429 {
				retryStrategy = responseErrorManager.onError(httpError, attemptCount: attemptCount)
			} else {
				retryStrategy = .NONE
			}

			switch retryStrategy {
			case .NONE:
				throw httpError
			case let .BACKOFF(duration):
				try await Task.sleep(seconds: duration)
				return try await execute(attemptCount: attemptCount + 1)
			}

		} catch {
			try Task.checkCancellation()

			let retryStrategy: RetryStrategy = if isTimeoutError(error) {
				timeoutErrorManager.onError(error, attemptCount: attemptCount)
			} else if isNetworkError(error) {
				networkErrorManager.onError(error, attemptCount: attemptCount)
			} else {
				.NONE
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
		// URLErrors are no longer wrapped - check directly
		if let urlError = error as? URLError {
			return urlError.code == .timedOut
		}

		// Check wrapped errors (TidalError, TidalAPIError)
		if let underlyingError = underlyingError(from: error) {
			return isTimeoutError(underlyingError)
		}

		return false
	}

	private func isNetworkError(_ error: Error) -> Bool {
		// URLErrors are no longer wrapped - check directly
		if let urlError = error as? URLError {
			switch urlError.code {
			case .networkConnectionLost, .notConnectedToInternet,
			     .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
				return true
			default:
				return false
			}
		}

		// Check wrapped errors (TidalError, TidalAPIError)
		if let underlyingError = underlyingError(from: error) {
			return isNetworkError(underlyingError)
		}

		return false
	}

	private func underlyingError(from error: Error) -> Error? {
		if let tidalError = error as? TidalError {
			return tidalError.throwable
		}

		if let tidalAPIError = error as? TidalAPIError {
			return tidalAPIError.underlyingError
		}

		return nil
	}
}
