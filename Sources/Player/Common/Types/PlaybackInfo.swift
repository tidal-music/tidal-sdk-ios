import Foundation

struct PlaybackInfo: Equatable {
	let productType: ProductType
	let productId: String
	let streamType: StreamType
	let assetPresentation: AssetPresentation
	let audioMode: AudioMode?
	let audioQuality: AudioQuality?
	let audioCodec: AudioCodec?
	let audioSampleRate: Int?
	let audioBitDepth: Int?
	let adaptiveAudioQualities: [AudioQuality]?
	let videoQuality: VideoQuality?
	let streamingSessionId: String?
	let contentHash: String
	let mediaType: String
	let url: URL
	let licenseSecurityToken: String?
	let albumReplayGain: Float?
	let albumPeakAmplitude: Float?
	let trackReplayGain: Float?
	let trackPeakAmplitude: Float?
	let offlineRevalidateAt: UInt64?
	let offlineValidUntil: UInt64?
	let isAdaptivePlaybackEnabled: Bool
}
