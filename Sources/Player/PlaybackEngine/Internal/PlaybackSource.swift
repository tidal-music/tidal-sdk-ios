import Foundation

enum PlaybackSource {
	case INTERNET
	case LOCAL_STORAGE
	case LOCAL_STORAGE_LEGACY

	func isOfflineSource() -> Bool {
		switch self {
		case .LOCAL_STORAGE, .LOCAL_STORAGE_LEGACY:
			true
		case .INTERNET:
			false
		}
	}
}
