import Foundation

// MARK: - PlaybackInfoErrorResponseConverter

enum PlaybackInfoErrorResponseConverter {
	static func convert(_ error: Error) -> Error {
		if error is TokenRenewalFailed {
			return PlaybackInfoFetcherError.unableToRenewAccessToken.error(.PERetryable)
		}

		guard let httpError = error as? HttpError else {
			return error
		}

		switch httpError {
		case let .httpClientError(statusCode, message):
			return convertClientError(status: statusCode, data: message)
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
	static func convertClientError(status: Int, data: Data?) -> Error {
		let subStatus = extractSubStatus(from: data)

		switch status {
		case 401:
			return AuthError(status: subStatus)
		case 403:
			return handleForbidden(with: subStatus)
		case 404:
			return handleNotFound(with: subStatus)
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

	static func handleForbidden(with subStatus: Int?) -> Error {
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

	static func handleNotFound(with subStatus: Int?) -> Error {
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
