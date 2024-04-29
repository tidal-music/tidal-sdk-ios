import Foundation

struct BroadcastPlaybackInfo: Decodable {
	let id: String
	let audioQuality: AudioQuality
	let manifestType: String
	let manifest: String
}
