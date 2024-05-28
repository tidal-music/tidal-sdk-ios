import Foundation

public typealias PlayerAudioMode = AudioMode

// MARK: - AudioMode

public enum AudioMode: String, Codable {
	case STEREO
	case SONY_360RA
	case DOLBY_ATMOS
}
