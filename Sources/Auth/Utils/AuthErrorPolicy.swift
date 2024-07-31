import Common
import Foundation

// MARK: - AuthErrorPolicy

/// Implement this interface to create a handler to transform throwables
/// thrown while executing [retryWithPolicy] into an [AuthResult]
protocol AuthErrorPolicy {
	func handleError<T>(errorResponse: ErrorResponse?, throwable: Error?) -> AuthResult<T>
}

// MARK: - DefaultAuthErrorPolicy

final class DefaultAuthErrorPolicy: AuthErrorPolicy {
	func handleError<T>(errorResponse: ErrorResponse?, throwable: Error?) -> AuthResult<T> {
		guard let throwable = throwable as? NetworkError else {
			return .failure(NetworkError(code: "0", throwable: throwable))
		}

		let subStatus = throwable.getErrorResponse()?.subStatus
		if throwable.isClientError {
			return .failure(UnexpectedError(code: throwable.code, subStatus: subStatus, throwable: throwable))
		}

		if throwable.isServerError {
			return .failure(RetryableError(code: throwable.code, subStatus: subStatus, throwable: throwable))
		}

		return .failure(NetworkError(code: "1", throwable: throwable))
	}
}
