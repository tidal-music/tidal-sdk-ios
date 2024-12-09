import Foundation

public typealias PlayerAudioCodec = AudioCodec

// MARK: - AudioCodec

/// Enum containing all the possible AudioCodec for the MediaProducts in our catalogue
public enum AudioCodec: Equatable, Codable {
	enum Constants {
		static let Manifest_Name_HE_AAC_V1 = "mp4a.40.5"
		static let Manifest_Name_AAC_LC = "mp4a.40.2"
		static let Manifest_Name_AAC = "aac"
		static let Manifest_Name_FLAC = "flac"
		static let Manifest_Name_ALAC = "alac"
		static let Manifest_Name_MQA = "mqa"
		static let Manifest_Name_AC4 = "ac4"
		static let Manifest_Name_EAC3 = "eac3"
		static let Manifest_Name_MHA1 = "mha1"
		static let Manifest_Name_MHM1 = "mhm1"
		static let Manifest_Name_MP3 = "mp3"

		static let Display_Name_AAC = "aac"
		static let Display_Name_MQA = "mqa"
		static let Display_Name_FLAC = "flac"
	}

	case HE_AAC_V1
	case AAC_LC
	case AAC
	case FLAC
	case ALAC
	case MQA
	case AC4
	case EAC3
	case MHA1
	case MHM1
	case MP3
	case UNKNOWN(value: String)

	// swiftlint:disable cyclomatic_complexity
	init?(rawValue: String?) {
		guard let rawValue, rawValue.isEmpty == false else {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.audioCodecInitWithEmpty)
			return nil
		}

		switch rawValue.lowercased() {
		case Constants.Manifest_Name_HE_AAC_V1:
			self = .HE_AAC_V1
		case Constants.Manifest_Name_AAC_LC:
			self = .AAC_LC
		case Constants.Manifest_Name_AAC:
			self = .AAC
		case Constants.Manifest_Name_FLAC:
			self = .FLAC
		case Constants.Manifest_Name_ALAC:
			self = .ALAC
		case Constants.Manifest_Name_MQA:
			self = .MQA
		case Constants.Manifest_Name_AC4:
			self = .AC4
		case Constants.Manifest_Name_EAC3:
			self = .EAC3
		case Constants.Manifest_Name_MHA1:
			self = .MHA1
		case Constants.Manifest_Name_MHM1:
			self = .MHM1
		case Constants.Manifest_Name_MP3:
			self = .MP3
		default:
			self = .UNKNOWN(value: rawValue)
			PlayerWorld.logger?.log(loggable: PlayerLoggable.audioCodecInitWithUnknown(codec: rawValue))
		}
	}

	// swiftlint:enable cyclomatic_complexity

	/// Initializer from a combination of AudioQuality and AudioMode values
	/// - Parameter quality: The AudioQuality value
	/// - Parameter mode: The AudioMode value
	public init?(from quality: AudioQuality?, mode: AudioMode?) {
		guard let quality else {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.audioCodecInitWithNilQuality(audioMode: mode?.rawValue ?? "nil"))
			return nil
		}
		switch quality {
		case AudioQuality.LOW:
			guard let mode else {
				PlayerWorld.logger?.log(loggable: PlayerLoggable.audioCodecInitWithLowQualityAndNilMode)
				return nil
			}
			switch mode {
			// We can't know the exact codec, but the client does not need it.
			case AudioMode.DOLBY_ATMOS, AudioMode.SONY_360RA:
				PlayerWorld.logger?.log(loggable: PlayerLoggable.audioCodecInitWithLowQualityAndUnsupportedMode(mode: mode.rawValue))
				return nil
			case AudioMode.STEREO: self = .HE_AAC_V1
			}
		case AudioQuality.HIGH: self = .AAC_LC
		case AudioQuality.LOSSLESS: self = .FLAC // Could be .ALAC, but we need to update Player to get that
		case AudioQuality.HI_RES: self = .MQA
		case AudioQuality.HI_RES_LOSSLESS: self = .FLAC
		}
	}
}

public extension AudioCodec {
	var displayName: String? {
		switch self {
		case .HE_AAC_V1, .AAC_LC, .AAC:
			Constants.Display_Name_AAC
		case .MQA:
			Constants.Display_Name_MQA
		case .FLAC:
			Constants.Display_Name_FLAC
		default:
			nil
		}
	}
}
