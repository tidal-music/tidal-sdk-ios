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
	private let authenticationErrorManager: TidalAPIAuthenticationErrorManager

	init(
		executionBlock: @escaping RequestBuilderExecutor<T>,
		responseErrorManager: ErrorManager = TidalAPIResponseErrorManager(),
		networkErrorManager: ErrorManager = TidalAPINetworkErrorManager(),
		timeoutErrorManager: ErrorManager = TidalAPITimeoutErrorManager(),
		authenticationErrorManager: TidalAPIAuthenticationErrorManager = TidalAPIAuthenticationErrorManager()
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

            let strategy: RetryStrategy = switch httpError.statusCode {
            case 401:
                await authenticationErrorManager.handleAuthenticationError(httpError, attemptCount: attemptCount)
            case 429, 500..<600:
                responseErrorManager.onError(httpError, attemptCount: attemptCount)
            default:
                .NONE
            }

            if case .BACKOFF(let duration) = strategy {
                try await Task.sleep(seconds: duration)
                return try await execute(attemptCount: attemptCount + 1)
            }
            
            throw httpError
		} catch {
			try Task.checkCancellation()

			let strategy: RetryStrategy = if isTimeoutError(error) {
				timeoutErrorManager.onError(error, attemptCount: attemptCount)
			} else if isNetworkError(error) {
				networkErrorManager.onError(error, attemptCount: attemptCount)
			} else {
				.NONE
			}

            if case .BACKOFF(let duration) = strategy {
                try await Task.sleep(seconds: duration)
                return try await execute(attemptCount: attemptCount + 1)
            }
            
            throw error
		}
	}

	private func isTimeoutError(_ error: Error) -> Bool {
		if let urlError = error as? URLError {
			return urlError.code == .timedOut
		}

		if let underlyingError = underlyingError(from: error) {
			return isTimeoutError(underlyingError)
		}

		return false
	}

	private func isNetworkError(_ error: Error) -> Bool {
		if let urlError = error as? URLError {
			switch urlError.code {
			case .networkConnectionLost, .notConnectedToInternet,
			     .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
				return true
			default:
				return false
			}
		}

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
