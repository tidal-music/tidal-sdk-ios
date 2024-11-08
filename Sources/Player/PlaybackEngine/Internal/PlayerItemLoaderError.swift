import Foundation

enum PlayerItemLoaderError: Int {
	case streamNotAllowedInOfflineMode = 1

	func error(_ errorId: ErrorId) -> Error {
		PlayerInternalError(
			errorId: errorId,
			errorType: .playerItemLoaderError,
			code: rawValue
		)
	}
}
