import Foundation

public typealias PlayerAudioQuality = AudioQuality

// MARK: - AudioQuality

public enum AudioQuality: String, Codable {
	enum Constants {
		static let Low_BitRate = 96000
		static let High_BitRate = 320_000
	}

	case LOW
	case HIGH
	case LOSSLESS
	case HI_RES
	case HI_RES_LOSSLESS
}

public extension AudioQuality {
	func toBitRate() -> Int? {
		switch self {
		case .LOW: AudioQuality.Constants.Low_BitRate
		case .HIGH: AudioQuality.Constants.High_BitRate
		default: nil
		}
	}
}
