import CoreAudio
import Foundation

public struct AssetPlaybackMetadata: Equatable {
	let sampleRate: Int
	let bitDepth: Int

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
		self.sampleRate = Int(sampleRateAsDouble)
		self.bitDepth = bitDepthAsInt
	}

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
			PlayerWorld.logger?.log(loggable: PlayerLoggable.assetPlaybackMetadataInitWithInvalidFormatFlags(formatFlags: String(describing: formatFlags)))
			return nil
		}

		self.sampleRate = Int(sampleRate)
		self.bitDepth = bitDepth
	}
}
