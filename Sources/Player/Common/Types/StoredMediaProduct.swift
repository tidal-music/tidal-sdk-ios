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
		referenceId: String?,
		progressSource: Source?,
		playLogSource: Source?,
		extras: [String: String?]?,
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
			referenceId: referenceId,
			progressSource: progressSource,
			playLogSource: playLogSource,
			extras: extras
		)
	}

	required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
}
