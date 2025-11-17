import CoreAudio
import Foundation

/// Metadata describing playback characteristics of an asset.
/// Combines real-time format information from HLS streams with audio technical details.
public struct AssetPlaybackMetadata: Equatable {
	/// Format string identifier (e.g., "FLAC", "AAC", "ALAC") from HLS timed metadata
	public let formatString: String
	/// Sample rate in Hz
	public let sampleRate: Int
	/// Bit depth in bits per sample
	public let bitDepth: Int

	/// Initialize from HLS format metadata with all required fields
	public init(formatString: String, sampleRate: Int, bitDepth: Int) {
		self.formatString = formatString
		self.sampleRate = sampleRate
		self.bitDepth = bitDepth
	}

	/// Initialize from external player metadata (sample rate and format flags from ALAC)
	public init?(sampleRate: Float64?, formatFlags: AudioFormatFlags?) {
		guard let sampleRate, let formatFlags else {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.assetPlaybackMetadataInitWithoutRequiredData)
			return nil
		}

		var bitDepth: Int
		if formatFlags == kAppleLosslessFormatFlag_16BitSourceData {
			bitDepth = 16
		} else if formatFlags == kAppleLosslessFormatFlag_24BitSourceData {
			bitDepth = 24
		} else if formatFlags == kAppleLosslessFormatFlag_32BitSourceData {
			bitDepth = 32
		} else {
			PlayerWorld.logger?
				.log(loggable: PlayerLoggable.assetPlaybackMetadataInitWithInvalidFormatFlags(formatFlags: String(describing: formatFlags)))
			return nil
		}

		self.formatString = "ALAC"
		self.sampleRate = Int(sampleRate)
		self.bitDepth = bitDepth
	}

	/// Initialize from backend metadata strings
	public init?(sampleRate: String?, bitDepth: String?) {
		guard
			let sampleRate,
			let sampleRateAsDouble = Double(sampleRate),
			let bitDepth,
			let bitDepthAsInt = Int(bitDepth)
		else {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.assetPlaybackMetadataInitWithoutRateAndDepthData)
			return nil
		}
		self.formatString = "UNKNOWN"
		self.sampleRate = Int(sampleRateAsDouble)
		self.bitDepth = bitDepthAsInt
	}

	public var description: String {
		"AssetPlaybackMetadata(format: \(formatString), sampleRate: \(sampleRate), bitDepth: \(bitDepth))"
	}

	/// Custom equality: compares all fields for reliable deduplication
	public static func == (lhs: AssetPlaybackMetadata, rhs: AssetPlaybackMetadata) -> Bool {
		lhs.formatString == rhs.formatString &&
		lhs.sampleRate == rhs.sampleRate &&
		lhs.bitDepth == rhs.bitDepth
	}
}
