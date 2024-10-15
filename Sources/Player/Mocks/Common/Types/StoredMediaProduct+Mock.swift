import Foundation

public extension StoredMediaProduct {
	static func mock(
		productType: ProductType = .TRACK,
		productId: String = "1",
		referenceId: String? = nil,
		progressSource: Source? = nil,
		playLogSource: Source? = nil,
		extras: Extras? = nil,
		assetPresentation: AssetPresentation = .FULL,
		audioMode: AudioMode? = nil,
		audioQuality: AudioQuality? = nil,
		audioCodec: AudioCodec? = nil,
		audioSampleRate: Int? = nil,
		audioBitDepth: Int? = nil,
		videoQuality: VideoQuality? = nil,
		albumReplayGain: Float? = nil,
		albumPeakAmplitude: Float? = nil,
		trackReplayGain: Float? = nil,
		trackPeakAmplitude: Float? = nil,
		url: URL = URL(string: "https://www.tidal.com")!
	) -> StoredMediaProduct {
		StoredMediaProduct(
			productType: productType,
			productId: productId,
			referenceId: referenceId,
			progressSource: progressSource,
			playLogSource: playLogSource,
			extras: nil,
			assetPresentation: assetPresentation,
			audioMode: audioMode,
			audioQuality: audioQuality,
			audioCodec: audioCodec,
			audioSampleRate: audioSampleRate,
			audioBitDepth: audioBitDepth,
			videoQuality: videoQuality,
			albumReplayGain: albumReplayGain,
			albumPeakAmplitude: albumPeakAmplitude,
			trackReplayGain: trackReplayGain,
			trackPeakAmplitude: trackPeakAmplitude,
			url: url
		)
	}
}
