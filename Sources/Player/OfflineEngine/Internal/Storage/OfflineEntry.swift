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
	let licenseSecurityToken: String?
	let size: Int
	var mediaURL: URL?
	var licenseURL: URL?

	var state: InternalOfflineState {
		let needsLicense = needsLicense()
		guard
			let mediaURL,
			!needsLicense || (needsLicense && licenseURL != nil)
		else {
			return .OFFLINED_BUT_NO_LICENSE
		}

		let now = PlayerWorld.timeProvider.timestamp()
		if let expiry, now > expiry * 1000 {
			return .OFFLINED_BUT_EXPIRED
		}

		if mediaType == MediaTypes.HLS {
			let asset = AVURLAsset(url: mediaURL)
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
		licenseSecurityToken: String?,
		size: Int,
		mediaURL: URL?,
		licenseURL: URL?
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
		self.licenseSecurityToken = licenseSecurityToken
		self.size = size
		self.mediaURL = mediaURL
		self.licenseURL = licenseURL
	}

	init(
		from playbackInfo: PlaybackInfo,
		with mediaURL: URL,
		and licenseURL: URL?,
		size: Int
	) throws {
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
		licenseSecurityToken = playbackInfo.licenseSecurityToken
		self.size = size
		self.mediaURL = mediaURL
		self.licenseURL = licenseURL
	}

	func isPlayable() -> Bool {
		state == .OFFLINED_AND_VALID
	}

	func needsLicense() -> Bool {
		licenseSecurityToken != nil
	}
}
