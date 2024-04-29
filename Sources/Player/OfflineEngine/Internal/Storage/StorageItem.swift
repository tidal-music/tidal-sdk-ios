import AVFoundation
import Foundation

struct StorageItem: Codable {
	let productType: ProductType
	let productId: String
	let assetPresentation: AssetPresentation
	let audioMode: AudioMode?
	let audioQuality: AudioQuality?
	let audioCodec: AudioCodec?
	let audioSampleRate: Int?
	let audioBitDepth: Int?
	let videoQuality: VideoQuality?
	let revalidateAt: UInt64?
	let expiry: UInt64?
	let mediaType: String?
	let albumReplayGain: Float?
	let albumPeakAmplitude: Float?
	let trackReplayGain: Float?
	let trackPeakAmplitude: Float?
	let mediaBookmark: Data
	let licenseBookmark: Data?

	var mediaUrl: URL? {
		var isStale = false
		guard let url = try? URL(resolvingBookmarkData: mediaBookmark, bookmarkDataIsStale: &isStale), !isStale else {
			return nil
		}

		return url
	}

	var licenseUrl: URL? {
		var isStale = false
		guard let licenseBookmark,
		      let url = try? URL(resolvingBookmarkData: licenseBookmark, bookmarkDataIsStale: &isStale),
		      !isStale
		else {
			return nil
		}

		return url
	}

	init(from playbackInfo: PlaybackInfo, with assetUrl: URL, and licenseUrl: URL?) throws {
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
		mediaBookmark = try assetUrl.bookmarkData()
		licenseBookmark = try licenseUrl?.bookmarkData()
	}

	func state() -> OfflineState {
		guard let mediaUrl else {
			return .OFFLINED_BUT_NOT_VALID
		}

		if licenseBookmark != nil, licenseUrl == nil {
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
}
