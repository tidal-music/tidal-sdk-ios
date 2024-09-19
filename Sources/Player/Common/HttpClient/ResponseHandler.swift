import Common
import Foundation

typealias ExecutionBlock = (_ request: URLRequest) async throws -> RequestResponse

// MARK: - ResponseHandler

final class ResponseHandler {
	private var request: URLRequest
	private var executionBlock: ExecutionBlock
	private let responseErrorManager: ErrorManager
	private let networkErrorManager: ErrorManager
	private let timeoutErrorManager: ErrorManager

	public init(
		request: URLRequest,
		executionBlock: @escaping ExecutionBlock,
		responseErrorManager: ErrorManager,
		networkErrorManager: ErrorManager,
		timeoutErrorManager: ErrorManager
	) {
		self.request = request
		self.executionBlock = executionBlock
		self.responseErrorManager = responseErrorManager
		self.networkErrorManager = networkErrorManager
		self.timeoutErrorManager = timeoutErrorManager
	}

	func handle(attemptCount validationAttemptCount: Int = 0) async throws -> Data? {
		let response = try await execute()
		try Task.checkCancellation()
		return try await validate(response, attemptCount: validationAttemptCount)
	}

	func execute(attemptCount: Int = 0) async throws -> RequestResponse {
		do {
			return try await executionBlock(request)
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.backoffHandleResponseFailed(error: error))
			let retryStrategy: RetryStrategy = if isTimeoutError(error: error) {
				timeoutErrorManager.onError(error, attemptCount: attemptCount)
			} else {
				networkErrorManager.onError(error, attemptCount: attemptCount)
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

	func validate(_ response: RequestResponse, attemptCount: Int) async throws -> Data? {
		var responseError: Error?
		var responseData: Data?

		if let urlResponse = response.urlResponse {
			switch urlResponse.statusCode {
			case 200 ... 299:
				responseData = response.data
			case 400 ... 499:
				responseError = HttpError.httpClientError(statusCode: urlResponse.statusCode, message: response.data)
			case 500 ... 599:
				responseError = HttpError.httpServerError(statusCode: urlResponse.statusCode)
			default:
				responseError = ErrorCode.unsupportedHttpStatus
					.toPlayerInternalError(description: "Received http status \(urlResponse.statusCode)")
			}
		} else {
			responseError = ErrorCode.noResponse.toPlayerInternalError()
		}

		if let error = responseError {
			let retryStrategy = responseErrorManager.onError(error, attemptCount: attemptCount)
			switch retryStrategy {
			case .NONE:
				throw error
			case let .BACKOFF(duration):
				try await Task.sleep(seconds: duration)
				return try await handle(attemptCount: attemptCount + 1)
			}
		} else {
			return responseData
		}
	}
}

private extension ResponseHandler {
	func isTimeoutError(error: Error) -> Bool {
		guard let playerError = error as? PlayerInternalError else {
			return false
		}
		return playerError.errorType == .timeOutError
	}
}
