import Foundation

struct Metadata: Equatable {
	let productId: String
	let streamType: StreamType
	let assetPresentation: AssetPresentation
	let audioMode: AudioMode?
	var audioQuality: AudioQuality?
	let audioCodec: AudioCodec?
	let audioSampleRate: Int?
	let audioBitDepth: Int?
	let videoQuality: VideoQuality?
	let adaptiveAudioQualities: [AudioQuality]?
	let playbackSource: PlaybackSource
}
