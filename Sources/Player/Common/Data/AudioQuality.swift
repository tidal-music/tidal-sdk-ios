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

	/// Typical advertised bitrates (in bits per second) used to approximate adaptive switches.
	var typicalBitrate: Double {
		switch self {
		case .LOW:
			return 96_000
		case .HIGH:
			return 320_000
		case .LOSSLESS:
			return 1_411_200
		case .HI_RES:
			return 2_304_000
		case .HI_RES_LOSSLESS:
			return 4_608_000
		}
	}
}
