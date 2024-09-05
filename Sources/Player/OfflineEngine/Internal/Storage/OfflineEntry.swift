import AVFoundation
import Foundation

struct OfflineEntry: Codable {
	let productId: String
	let productType: ProductType
	let assetPresentation: AssetPresentation
	let audioMode: AudioMode?
	let audioQuality: AudioQuality?
	let audioCodec: AudioCodec?
	let audioSampleRate: Int?
	let audioBitDepth: Int?
	let videoQuality: VideoQuality?
	var revalidateAt: UInt64?
	var expiry: UInt64?
	let mediaType: String?
	let albumReplayGain: Float?
	let albumPeakAmplitude: Float?
	let trackReplayGain: Float?
	let trackPeakAmplitude: Float?
	var mediaUrl: URL?
	var licenseUrl: URL?

	var state: OfflineState {
		guard let mediaUrl, let licenseUrl else {
			return .OFFLINED_BUT_NOT_VALID
		}

		let now = PlayerWorld.timeProvider.timestamp()
		if let expiry, now > expiry * 1000 {
			return .OFFLINED_BUT_NOT_VALID
		}

		if mediaType == MediaTypes.HLS {
			let asset = AVURLAsset(url: mediaUrl)
			guard let cache = asset.assetCache, cache.isPlayableOffline else {
				return .OFFLINED_BUT_NOT_VALID
			}
		}

		return .OFFLINED_AND_VALID
	}

	init(
		productId: String,
		productType: ProductType,
		assetPresentation: AssetPresentation,
		audioMode: AudioMode?,
		audioQuality: AudioQuality?,
		audioCodec: AudioCodec?,
		audioSampleRate: Int?,
		audioBitDepth: Int?,
		videoQuality: VideoQuality?,
		revalidateAt: UInt64?,
		expiry: UInt64?,
		mediaType: String?,
		albumReplayGain: Float?,
		albumPeakAmplitude: Float?,
		trackReplayGain: Float?,
		trackPeakAmplitude: Float?,
		mediaUrl: URL?,
		licenseUrl: URL?
	) {
		self.productId = productId
		self.productType = productType
		self.assetPresentation = assetPresentation
		self.audioMode = audioMode
		self.audioQuality = audioQuality
		self.audioCodec = audioCodec
		self.audioSampleRate = audioSampleRate
		self.audioBitDepth = audioBitDepth
		self.videoQuality = videoQuality
		self.revalidateAt = revalidateAt
		self.expiry = expiry
		self.mediaType = mediaType
		self.albumReplayGain = albumReplayGain
		self.albumPeakAmplitude = albumPeakAmplitude
		self.trackReplayGain = trackReplayGain
		self.trackPeakAmplitude = trackPeakAmplitude
		self.mediaUrl = mediaUrl
		self.licenseUrl = licenseUrl
	}

	init(from playbackInfo: PlaybackInfo, with mediaUrl: URL, and licenseUrl: URL?) throws {
		productType = playbackInfo.productType
		productId = playbackInfo.productId
		assetPresentation = playbackInfo.assetPresentation
		audioMode = playbackInfo.audioMode
		audioQuality = playbackInfo.audioQuality
		audioCodec = playbackInfo.audioCodec
		audioSampleRate = playbackInfo.audioSampleRate
		audioBitDepth = playbackInfo.audioBitDepth
		videoQuality = playbackInfo.videoQuality
		revalidateAt = playbackInfo.offlineRevalidateAt
		expiry = playbackInfo.offlineValidUntil
		mediaType = playbackInfo.mediaType
		albumReplayGain = playbackInfo.albumReplayGain
		albumPeakAmplitude = playbackInfo.albumPeakAmplitude
		trackReplayGain = playbackInfo.trackReplayGain
		trackPeakAmplitude = playbackInfo.trackPeakAmplitude
		self.mediaUrl = mediaUrl
		self.licenseUrl = licenseUrl
	}
}
