import Foundation

struct PlayableOfflinedMediaProduct: Equatable {
	let productType: ProductType
	let productId: String
	let assetPresentation: AssetPresentation
	let audioMode: AudioMode?
	let audioQuality: AudioQuality?
	let audioCodec: AudioCodec?
	let audioSampleRate: Int?
	let audioBitDepth: Int?
	let videoQuality: VideoQuality?
	let mediaURL: URL
	let licenseURL: URL?
	let albumReplayGain: Float?
	let albumPeakAmplitude: Float?
	let trackReplayGain: Float?
	let trackPeakAmplitude: Float?

	init?(from offlineEntry: OfflineEntry) {
		guard
			offlineEntry.state == .OFFLINED_AND_VALID,
			let URL = offlineEntry.mediaURL
		else {
			return nil
		}

		productType = offlineEntry.productType
		productId = offlineEntry.productId
		assetPresentation = offlineEntry.assetPresentation
		audioMode = offlineEntry.audioMode
		audioQuality = offlineEntry.audioQuality
		audioCodec = offlineEntry.audioCodec
		audioSampleRate = offlineEntry.audioSampleRate
		audioBitDepth = offlineEntry.audioBitDepth
		videoQuality = offlineEntry.videoQuality
		mediaURL = URL
		licenseURL = offlineEntry.licenseURL
		albumReplayGain = offlineEntry.albumReplayGain
		albumPeakAmplitude = offlineEntry.albumPeakAmplitude
		trackReplayGain = offlineEntry.trackReplayGain
		trackPeakAmplitude = offlineEntry.trackPeakAmplitude
	}
}
