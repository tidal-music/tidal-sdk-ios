import Foundation
import TidalAPI

// MARK: - PlaybackInfoErrorResponseConverter

enum PlaybackInfoErrorResponseConverter {
	static func convert(_ error: Error) -> Error {
		// Handle TidalAPIError from new endpoints
		if let tidalAPIError = error as? HTTPErrorResponse {
			return convertTidalAPIError(tidalAPIError)
		}

		// Handle HttpError from legacy endpoints
		guard let httpError = error as? HttpError else {
			return error
		}

		switch httpError {
		case let .httpClientError(statusCode, message):
			return convertClientError(status: statusCode, data: message, subStatus: nil)
		case let .httpServerError(statusCode):
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .playbackInfoServerError,
				code: statusCode
			)
		}
	}
}

private extension PlaybackInfoErrorResponseConverter {
	static func convertTidalAPIError(_ error: HTTPErrorResponse) -> Error {
        switch error.statusCode {
		case 401:
			return AuthError(status: nil)
		case 403:
            return handleForbidden(with: nil, errorCode: extractErrorCode(from: error))
		case 404:
			return handleNotFound(with: nil, errorCode: extractErrorCode(from: error))
		case 429:
			return PlaybackInfoFetcherError.rateLimited.error(.PERetryable)
		case 500...599:
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .playbackInfoServerError,
                code: error.statusCode
			)
		default:
			return PlaybackInfoFetcherError.unHandledHttpStatus.error(.EUnexpected)
		}
	}

	static func convertClientError(status: Int, data: Data?, subStatus: Int? = nil) -> Error {
		let extractedSubStatus = subStatus ?? extractSubStatus(from: data)

		switch status {
		case 401:
			return AuthError(status: extractedSubStatus)
		case 403:
			return handleForbidden(with: extractedSubStatus, errorCode: nil)
		case 404:
			return handleNotFound(with: extractedSubStatus, errorCode: nil)
		case 429:
			return PlaybackInfoFetcherError.rateLimited.error(.PERetryable)
		default:
			return PlaybackInfoFetcherError.unHandledHttpStatus.error(.EUnexpected)
		}
	}

	static func extractSubStatus(from data: Data?) -> Int? {
		guard let data else {
			return nil
		}

		guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
			return nil
		}

		guard let deserialized = json as? [String: Any] else {
			return nil
		}

		guard let subStatus = deserialized["subStatus"] else {
			return nil
		}

		return subStatus as? Int
	}
    
    static func extractErrorCode(from error: HTTPErrorResponse) -> String {
        if case .some(let code) = error.errorObject()?.code {
            return code
        }
        
        return "NA"
    }

	static func handleForbidden(with subStatus: Int?, errorCode: String?) -> Error {
		// Check for CONCURRENCY_LIMIT (maps to retry, but we handle it specially here)
		if errorCode == "CONCURRENCY_LIMIT" || errorCode == "CONCURRENT_PLAYBACK" {
			return StreamingPrivilegesLostError()
		}

		// Prefer new error code format if available
		if let errorCode = errorCode {
			return PlayerInternalError(
				errorId: ErrorId.playbackErrorId(from: errorCode),
				errorType: .playbackInfoForbidden,
				code: 403
			)
		}

		// Fall back to legacy subStatus handling
		guard let subStatus else {
			return PlaybackInfoFetcherError.noResponseSubStatus.error(.EUnexpected)
		}

		if subStatus == 4006 {
			return StreamingPrivilegesLostError()
		}

		return PlayerInternalError(
			errorId: ErrorId.playbackErrorId(from: subStatus),
			errorType: .playbackInfoForbidden,
			code: subStatus
		)
	}

	static func handleNotFound(with subStatus: Int?, errorCode: String?) -> Error {
		// Prefer new error code format if available
		if let errorCode = errorCode {
			return PlayerInternalError(
				errorId: ErrorId.playbackErrorId(from: errorCode),
				errorType: .playbackInfoNotFound,
				code: 404
			)
		}

		// Fall back to legacy subStatus handling
		guard let subStatus else {
			return PlaybackInfoFetcherError.noResponseSubStatus.error(.EUnexpected)
		}

		return PlayerInternalError(
			errorId: .PENotAllowed,
			errorType: .playbackInfoNotFound,
			code: subStatus
		)
	}
}
