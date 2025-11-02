import Foundation
import TidalAPI

// MARK: - PlaybackInfoErrorResponseConverter

enum PlaybackInfoErrorResponseConverter {
	static func convert(_ error: Error) -> Error {
		// Handle TidalAPIError from new endpoints
		if let tidalAPIError = error as? TidalAPIError {
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
	static func convertTidalAPIError(_ error: TidalAPIError) -> Error {
		guard let statusCode = error.statusCode else {
			return error
		}

		let subStatus = error.subStatus
		let errorCode = error.errorObject?.code

		switch statusCode {
		case 401:
			return AuthError(status: subStatus)
		case 403:
			return handleForbidden(with: subStatus, errorCode: errorCode)
		case 404:
			return handleNotFound(with: subStatus, errorCode: errorCode)
		case 429:
			return PlaybackInfoFetcherError.rateLimited.error(.PERetryable)
		case 500...599:
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .playbackInfoServerError,
				code: statusCode
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

	static func handleForbidden(with subStatus: Int?, errorCode: String?) -> Error {
		// Check for CONCURRENCY_LIMIT (maps to retry, but we handle it specially here)
		if errorCode == "CONCURRENCY_LIMIT" {
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
