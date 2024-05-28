import Foundation

struct PlayableStorageItem: Equatable {
	let productType: ProductType
	let productId: String
	let assetPresentation: AssetPresentation
	let audioMode: AudioMode?
	let audioQuality: AudioQuality?
	let audioCodec: AudioCodec?
	let audioSampleRate: Int?
	let audioBitDepth: Int?
	let videoQuality: VideoQuality?
	let mediaUrl: URL
	let licenseUrl: URL?
	let albumReplayGain: Float?
	let albumPeakAmplitude: Float?
	let trackReplayGain: Float?
	let trackPeakAmplitude: Float?

	init?(from storageItem: StorageItem?) {
		guard let storageItem, storageItem.state() == .OFFLINED_AND_VALID, let url = storageItem.mediaUrl else {
			return nil
		}

		productType = storageItem.productType
		productId = storageItem.productId
		assetPresentation = storageItem.assetPresentation
		audioMode = storageItem.audioMode
		audioQuality = storageItem.audioQuality
		audioCodec = storageItem.audioCodec
		audioSampleRate = storageItem.audioSampleRate
		audioBitDepth = storageItem.audioBitDepth
		videoQuality = storageItem.videoQuality
		mediaUrl = url
		licenseUrl = storageItem.licenseUrl
		albumReplayGain = storageItem.albumReplayGain
		albumPeakAmplitude = storageItem.albumPeakAmplitude
		trackReplayGain = storageItem.trackReplayGain
		trackPeakAmplitude = storageItem.trackPeakAmplitude
	}
}
