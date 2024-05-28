import Foundation

public typealias PlayerVideoQuality = VideoQuality

// MARK: - VideoQuality

public enum VideoQuality: String, Codable {
	case AUDIO_ONLY
	case LOW
	case MEDIUM
	case HIGH
}
