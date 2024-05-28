import Foundation

struct TrackPlaybackInfo: Codable {
	let trackId: Int
	let assetPresentation: AssetPresentation
	let audioMode: AudioMode
	let audioQuality: AudioQuality
	let streamingSessionId: String?
	let licenseSecurityToken: String?
	let manifestMimeType: String
	let manifestHash: String
	let manifest: String
	let albumReplayGain: Float?
	let albumPeakAmplitude: Float?
	let trackReplayGain: Float?
	let trackPeakAmplitude: Float?
	let offlineRevalidateAt: UInt64?
	let offlineValidUntil: UInt64?
	let sampleRate: Int?
	let bitDepth: Int?
}
