import Foundation

struct Metadata: Equatable {
	let productId: String
	let streamType: StreamType
	let assetPresentation: AssetPresentation
	let audioMode: AudioMode?
	let audioQuality: AudioQuality?
	let audioCodec: AudioCodec?
	let audioSampleRate: Int?
	let audioBitDepth: Int?
	let videoQuality: VideoQuality?
	let playbackSource: PlaybackSource
}
