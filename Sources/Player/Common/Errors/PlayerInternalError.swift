import AVFoundation
import Foundation

// MARK: - PlayerInternalError

public struct PlayerInternalError: Error, CustomStringConvertible, Equatable {
	public enum ErrorType: Int {
		case playbackInfoForbidden = 0
		case playbackInfoNotFound
		case playbackInfoServerError
		case playbackInfoFetcherError
		case drmLicenseError
		case urlSessionError
		case networkError
		case timeOutError
		case httpClientError
		case avPlayerAvError
		case avPlayerUrlError
		case avPlayerOtherError
		case externalPlayerError
		case authError
		case unknown
		case playerLoaderError
	}

	let errorId: ErrorId
	let errorType: ErrorType
	let errorCode: Int
	let technicalDescription: String?

	var code: String {
		"\(errorType.rawValue):\(errorCode)"
	}

	public var description: String {
		"\(errorId) (\(code)) - [\(technicalDescription ?? "NA")]"
	}

	public init(errorId: ErrorId, errorType: ErrorType, code: Int, description: String? = nil) {
		self.errorId = errorId
		self.errorType = errorType
		errorCode = code
		technicalDescription = description
	}

	static func from(_ error: Error) -> PlayerInternalError {
		if let internalError = error as? PlayerInternalError {
			return internalError
		}

		return PlayerInternalError(
			errorId: .EUnexpected,
			errorType: .unknown,
			code: (error as NSError).code,
			description: String(describing: error)
		)
	}

	func toPlayerError() -> PlayerError {
		PlayerError(errorId: errorId, errorCode: code)
	}
}

extension Error {
	func isNetworkError() -> Bool {
		(self as? PlayerInternalError)?.errorType == .networkError
	}
}
