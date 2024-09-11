import Foundation
@testable import Player

extension OfflineEntry {
	static func mock(
		productId: String,
		productType: ProductType = ProductType.TRACK,
		size: Int = 0,
		url: URL
	) -> OfflineEntry {
		OfflineEntry(
			productId: productId,
			productType: productType,
			assetPresentation: .FULL,
			audioMode: .STEREO,
			audioQuality: .HIGH,
			audioCodec: .FLAC,
			audioSampleRate: 44100,
			audioBitDepth: 16,
			videoQuality: nil,
			revalidateAt: nil,
			expiry: nil,
			mediaType: MediaTypes.HLS,
			albumReplayGain: nil,
			albumPeakAmplitude: nil,
			trackReplayGain: nil,
			trackPeakAmplitude: nil,
			size: size,
			mediaUrl: url,
			licenseUrl: nil
		)
	}
}
