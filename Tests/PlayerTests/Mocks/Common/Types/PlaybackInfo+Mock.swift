import Foundation
@testable import Player

extension PlaybackInfo {
	static func mock(
		productType: ProductType = .TRACK,
		productId: String = "1",
		streamType: StreamType = .ON_DEMAND,
		assetPresentation: AssetPresentation = .FULL,
		audioMode: AudioMode? = .STEREO,
		audioQuality: AudioQuality? = .HI_RES_LOSSLESS,
		audioCodec: AudioCodec? = nil,
		audioSampleRate: Int? = nil,
		audioBitDepth: Int? = nil,
		adaptiveAudioQualities: [AudioQuality]? = nil,
		videoQuality: VideoQuality? = nil,
		streamingSessionId: String? = "streamingSessionId",
		contentHash: String = "contentHash",
		mediaType: String = MediaTypes.EMU,
		url: URL = URL(string: "https://www.tidal.com")!,
		licenseSecurityToken: String? = nil,
		albumReplayGain: Float? = nil,
		albumPeakAmplitude: Float? = nil,
		trackReplayGain: Float? = nil,
		trackPeakAmplitude: Float? = nil,
		offlineRevalidateAt: UInt64? = nil,
		offlineValidUntil: UInt64? = nil,
		isAdaptivePlaybackEnabled: Bool = false,
		previewReason: PreviewReason? = nil
	) -> Self {
		PlaybackInfo(
			productType: productType,
			productId: productId,
			streamType: streamType,
			assetPresentation: assetPresentation,
			audioMode: audioMode,
			audioQuality: audioQuality,
			audioCodec: audioCodec,
			audioSampleRate: audioSampleRate,
			audioBitDepth: audioBitDepth,
			adaptiveAudioQualities: adaptiveAudioQualities,
			videoQuality: videoQuality,
			streamingSessionId: streamingSessionId,
			contentHash: contentHash,
			mediaType: mediaType,
			url: url,
			licenseSecurityToken: licenseSecurityToken,
			albumReplayGain: albumReplayGain,
			albumPeakAmplitude: albumPeakAmplitude,
			trackReplayGain: trackReplayGain,
			trackPeakAmplitude: trackPeakAmplitude,
			offlineRevalidateAt: offlineRevalidateAt,
			offlineValidUntil: offlineValidUntil,
			isAdaptivePlaybackEnabled: isAdaptivePlaybackEnabled,
			previewReason: previewReason
		)
	}

}
