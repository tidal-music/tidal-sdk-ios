import CoreAudio
import Foundation
import TidalAPI

public struct AssetPlaybackMetadata: Equatable {
	public let audioQuality: AudioQuality
	public let audioMode: AudioMode
	public let sampleRate: Int?
	public let bitDepth: Int?

	public init(formatString: String, sampleRate: Int? = nil, bitDepth: Int? = nil) {
		let format = TrackManifestsAttributes.Formats(rawValue: formatString) ?? .heaacv1
		audioQuality = Self.audioQuality(of: format)
		audioMode = Self.audioMode(of: format)
		self.sampleRate = sampleRate
		self.bitDepth = bitDepth
	}

	public init(audioQuality: AudioQuality, audioMode: AudioMode, sampleRate: Int?, bitDepth: Int?) {
		self.audioQuality = audioQuality
		self.audioMode = audioMode
		self.sampleRate = sampleRate
		self.bitDepth = bitDepth
	}

	public var description: String {
		let srDesc = sampleRate.map { String($0) } ?? "nil"
		let bdDesc = bitDepth.map { String($0) } ?? "nil"
		return "AssetPlaybackMetadata(sampleRate: \(srDesc), bitDepth: \(bdDesc), audioQuality: \(audioQuality), audioMode: \(audioMode))"
	}

	public static func == (lhs: AssetPlaybackMetadata, rhs: AssetPlaybackMetadata) -> Bool {
		lhs.audioQuality == rhs.audioQuality &&
			lhs.audioMode == rhs.audioMode &&
			lhs.sampleRate == rhs.sampleRate &&
			lhs.bitDepth == rhs.bitDepth
	}

	private static func audioQuality(of format: TrackManifestsAttributes.Formats) -> AudioQuality {
		switch format {
		case .flacHires:
			.HI_RES_LOSSLESS
		case .flac:
			.LOSSLESS
		case .aaclc:
			.HIGH
		case .heaacv1, .eac3Joc:
			.LOW
		}
	}

	private static func audioMode(of format: TrackManifestsAttributes.Formats) -> AudioMode {
		switch format {
		case .eac3Joc:
			.DOLBY_ATMOS
		case .heaacv1, .aaclc, .flac, .flacHires:
			.STEREO
		}
	}
}
