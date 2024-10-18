import Foundation
@testable import Player

extension OfflineEntry {
	static func mock(
		productId: String,
		productType: ProductType = ProductType.TRACK,
		size: Int = 0,
		URL: URL
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
			licenseSecurityToken: nil,
			size: size,
			mediaURL: URL,
			licenseURL: nil
		)
	}

	static func mock(
		from playbackInfo: PlaybackInfo = .mock(),
		assetURL: URL? = URL(string: "https://www.tidal.com")!,
		licenseURL: URL? = URL(string: "https://www.tidal.com/license")!,
		size: Int = 0
	) -> OfflineEntry {
		OfflineEntry(
			productId: playbackInfo.productId,
			productType: playbackInfo.productType,
			assetPresentation: playbackInfo.assetPresentation,
			audioMode: playbackInfo.audioMode,
			audioQuality: playbackInfo.audioQuality,
			audioCodec: playbackInfo.audioCodec,
			audioSampleRate: playbackInfo.audioSampleRate,
			audioBitDepth: playbackInfo.audioBitDepth,
			videoQuality: playbackInfo.videoQuality,
			revalidateAt: playbackInfo.offlineRevalidateAt,
			expiry: playbackInfo.offlineValidUntil,
			mediaType: playbackInfo.mediaType,
			albumReplayGain: playbackInfo.albumReplayGain,
			albumPeakAmplitude: playbackInfo.albumPeakAmplitude,
			trackReplayGain: playbackInfo.trackReplayGain,
			trackPeakAmplitude: playbackInfo.trackPeakAmplitude,
			licenseSecurityToken: playbackInfo.licenseSecurityToken,
			size: size,
			mediaURL: assetURL,
			licenseURL: licenseURL
		)
	}
}
