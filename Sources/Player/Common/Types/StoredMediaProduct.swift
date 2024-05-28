import Foundation

public final class StoredMediaProduct: MediaProduct {
	public let assetPresentation: AssetPresentation
	public let audioMode: AudioMode?
	public let audioQuality: AudioQuality?
	public let audioCodec: AudioCodec?
	public let audioSampleRate: Int?
	public let audioBitDepth: Int?
	public let videoQuality: VideoQuality?
	public let albumReplayGain: Float?
	public let albumPeakAmplitude: Float?
	public let trackReplayGain: Float?
	public let trackPeakAmplitude: Float?
	public let url: URL

	public init(
		productType: ProductType,
		productId: String,
		progressSource: Source?,
		playLogSource: Source?,
		assetPresentation: AssetPresentation,
		audioMode: AudioMode?,
		audioQuality: AudioQuality?,
		audioCodec: AudioCodec?,
		audioSampleRate: Int?,
		audioBitDepth: Int?,
		videoQuality: VideoQuality?,
		albumReplayGain: Float?,
		albumPeakAmplitude: Float?,
		trackReplayGain: Float?,
		trackPeakAmplitude: Float?,
		url: URL
	) {
		self.assetPresentation = assetPresentation
		self.audioMode = audioMode
		self.audioQuality = audioQuality
		self.audioCodec = audioCodec
		self.audioSampleRate = audioSampleRate
		self.audioBitDepth = audioBitDepth
		self.videoQuality = videoQuality
		self.albumReplayGain = albumReplayGain
		self.albumPeakAmplitude = albumPeakAmplitude
		self.trackReplayGain = trackReplayGain
		self.trackPeakAmplitude = trackPeakAmplitude
		self.url = url

		super.init(
			productType: productType,
			productId: productId,
			progressSource: progressSource,
			playLogSource: playLogSource
		)
	}

	required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
}
