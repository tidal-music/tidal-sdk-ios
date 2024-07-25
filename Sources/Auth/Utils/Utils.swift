import Common
import Foundation

let HTTP_UNAUTHORIZED = 401
private let HTTP_CLIENT_ERROR_STATUS_START = 400
private let HTTP_SERVER_ERROR_STATUS_START = 500
private let HTTP_STATUS_END = 600

/// Lets an async func retry on a throwing block of code, following a RetryPolicy to define the
/// number and frequency of retries.
/// This means, when returning network calls , they can be retried automatically using
/// this function.
/// This function returns an AuthResult, this means no exceptions are thrown.
/// HTTP Exceptions are handled acoording to specs, all other potentially caught exceptions
/// will lead to a generic NSError at this point.
func retryWithPolicy<T>(
	_ retryPolicy: RetryPolicy,
	authErrorPolicy: AuthErrorPolicy? = nil,
	block: () async throws -> T,
	logError: ((Error) -> Void)? = nil
) async -> AuthResult<T> {
	var currentDelay = retryPolicy.delayMillis
	var attempts = 0
	var throwable: Error?
	var errorResponse: ErrorResponse?
	while retryPolicy.shouldRetry(errorResponse: errorResponse, throwable: throwable, attempt: attempts) {
		if let throwable {
			print("Retrying network call. Attempt \(attempts), exception: \(throwable.localizedDescription)")
			await sleep(currentDelay: currentDelay)
		}

		do {
			let result = try await block()
			return .success(result)
		} catch {
			throwable = error
			errorResponse = (throwable as? NetworkError)?.getErrorResponse()
		}

		attempts += 1
		currentDelay = (currentDelay * retryPolicy.delayFactor)
	}

	guard let throwable else {
		fatalError("A throwable was empty, while the retry function failed")
	}
	let result: AuthResult<T> = (authErrorPolicy ?? DefaultAuthErrorPolicy()).handleError(
		errorResponse: errorResponse,
		throwable: throwable
	)
	
	if case .failure(let error) = result {
		logError?(error)
	}
	
	return result
}

func retryWithPolicyUnwrapped<T>(_ retryPolicy: RetryPolicy, block: () async throws -> T) async throws -> T {
	var currentDelay = retryPolicy.delayMillis
	var attempts = 0
	var throwable: Error?

	while retryPolicy.shouldRetry(errorResponse: nil, throwable: throwable, attempt: attempts) {
		if let throwable {
			print("Retrying network call. Attempt \(attempts), exception: \(throwable.localizedDescription)")
			await sleep(currentDelay: currentDelay)
		}

		do {
			return try await block()
		} catch {
			throwable = error
		}

		attempts += 1
		currentDelay = (currentDelay * retryPolicy.delayFactor)
	}

	guard let throwable else {
		fatalError("A throwable was empty, while the retry function failed")
	}
	throw throwable
}

private func sleep(currentDelay: Int) async {
	try? await Task.sleep(nanoseconds: UInt64(currentDelay * 1_000_000))
}

extension Int {
	var toMilliseconds: Int {
		let MILLIS_MULTIPLIER = 1000
		return self * MILLIS_MULTIPLIER
	}
}

extension NetworkError {
	var isClientError: Bool {
		if let httpCode = Int(code) {
			return (HTTP_CLIENT_ERROR_STATUS_START ..< HTTP_SERVER_ERROR_STATUS_START).contains(httpCode)
		}

		return false
	}

	var isServerError: Bool {
		if let httpCode = Int(code) {
			return (HTTP_SERVER_ERROR_STATUS_START ..< HTTP_STATUS_END).contains(httpCode)
		}

		return false
	}
}

extension Int {
	var isServerError: Bool {
		(HTTP_SERVER_ERROR_STATUS_START ..< HTTP_STATUS_END).contains(self)
	}
}

extension String {
	var toInt: Int? {
		Int(self)
	}
}
