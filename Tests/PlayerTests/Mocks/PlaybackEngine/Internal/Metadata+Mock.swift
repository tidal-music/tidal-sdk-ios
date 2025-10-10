@testable import Player

extension Metadata {
	static func mock(
		productId: String = "1",
		streamType: StreamType = .ON_DEMAND,
		assetPresentation: AssetPresentation = .FULL,
		audioMode: AudioMode? = .STEREO,
		audioQuality: AudioQuality? = .LOSSLESS,
		audioCodec: AudioCodec? = nil,
		audioSampleRate: Int? = 44100,
		audioBitDepth: Int? = 15,
		videoQuality: VideoQuality? = nil,
		adaptiveAudioQualities: [AudioQuality]? = nil,
		playbackSource: PlaybackSource = .INTERNET
	) -> Self {
		Metadata(
			productId: productId,
			streamType: streamType,
			assetPresentation: assetPresentation,
			audioMode: audioMode,
			audioQuality: audioQuality,
			audioCodec: audioCodec,
			audioSampleRate: audioSampleRate,
			audioBitDepth: audioBitDepth,
			videoQuality: videoQuality,
			adaptiveAudioQualities: adaptiveAudioQualities,
			playbackSource: playbackSource
		)
	}

	static func mockFromTrackPlaybackInfo(
		productId: String = "1",
		trackPlaybackInfo: TrackPlaybackInfo = .mock()
	) -> Self {
		mock(
			productId: productId,
			assetPresentation: trackPlaybackInfo.assetPresentation,
			audioMode: trackPlaybackInfo.audioMode,
			audioQuality: trackPlaybackInfo.audioQuality,
			audioSampleRate: trackPlaybackInfo.sampleRate,
			audioBitDepth: trackPlaybackInfo.bitDepth,
			adaptiveAudioQualities: nil
		)
	}
}
