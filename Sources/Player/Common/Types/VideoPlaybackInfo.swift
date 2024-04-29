import Foundation

struct VideoPlaybackInfo: Decodable {
	let videoId: Int
	let streamType: StreamType
	let assetPresentation: AssetPresentation
	let videoQuality: VideoQuality
	let streamingSessionId: String?
	let licenseSecurityToken: String?
	let manifestMimeType: String
	let manifestHash: String?
	let manifest: String
	let albumReplayGain: Float?
	let albumPeakAmplitude: Float?
	let trackReplayGain: Float?
	let trackPeakAmplitude: Float?
	let offlineRevalidateAt: UInt64?
	let offlineValidUntil: UInt64?

	// TODO: AdInfo

	private enum CodingKeys: String, CodingKey {
		case videoId
		case streamType
		case assetPresentation
		case videoQuality
		case streamingSessionId
		case licenseSecurityToken
		case manifestMimeType
		case manifestHash
		case manifest
		case albumReplayGain
		case albumPeakAmplitude
		case trackReplayGain
		case trackPeakAmplitude
		case offlineRevalidateAt
		case offlineValidUntil
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		videoId = try container.decode(Int.self, forKey: .videoId)
		streamType = try container.decode(StreamType.self, forKey: .streamType)
		assetPresentation = try container.decode(AssetPresentation.self, forKey: .assetPresentation)
		videoQuality = try container.decode(VideoQuality.self, forKey: .videoQuality)
		streamingSessionId = try container.decodeIfPresent(String.self, forKey: .streamingSessionId)
		licenseSecurityToken = try container.decodeIfPresent(String.self, forKey: .licenseSecurityToken)
		manifestMimeType = try container.decode(String.self, forKey: .manifestMimeType)
		manifestHash = try container.decodeIfPresent(String.self, forKey: .manifestHash)
		manifest = try container.decode(String.self, forKey: .manifest)
		albumReplayGain = try container.decodeIfPresent(Float.self, forKey: .albumReplayGain)
		albumPeakAmplitude = try container.decodeIfPresent(Float.self, forKey: .albumPeakAmplitude)
		trackReplayGain = try container.decodeIfPresent(Float.self, forKey: .trackReplayGain)
		trackPeakAmplitude = try container.decodeIfPresent(Float.self, forKey: .trackPeakAmplitude)
		offlineRevalidateAt = try container.decodeIfPresent(UInt64.self, forKey: .offlineRevalidateAt)
		offlineValidUntil = try container.decodeIfPresent(UInt64.self, forKey: .offlineValidUntil)
	}
}
