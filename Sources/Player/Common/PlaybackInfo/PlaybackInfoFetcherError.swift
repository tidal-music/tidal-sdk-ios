import Foundation

enum PlaybackInfoFetcherError: Int {
	case unableToCreateUrl = 0
	case unableToExtractManifestUrl
	case unableToRenewAccessToken
	case rateLimited
	case noResponseData
	case noResponseSubStatus
	case unHandledHttpStatus

	func error(_ errorId: ErrorId) -> Error {
		PlayerInternalError(
			errorId: errorId,
			errorType: .playbackInfoFetcherError,
			code: rawValue
		)
	}
}
