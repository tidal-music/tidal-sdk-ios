import Foundation

/// Contains playback related information for active media product
///
@objc public final class PlaybackContext: NSObject {
	/// The product id of the media product being played.
	/// - Attention: Might differ from requested in case of a replacement.
	public let productId: String
	/// The stream type of the media product being played.
	/// - Attention: Might differ from requested in case of a replacement.
	public let streamType: StreamType
	/// The asset presentation of the media product being played.
	/// - Attention: Might differ from requested in case of a replacement.
	public let assetPresentation: AssetPresentation
	/// The audio mode of the media product being played.
	/// - Attention: Might differ from requested in case of a replacement.
	public let audioMode: AudioMode?
	/// The audio quality of the media product being played.
	/// - Attention: Might differ from requested in case of a replacement.
	public let audioQuality: AudioQuality?
	/// The codec name of the media product being played.
	public let audioCodec: String?
	/// The sample rate indicated in Hz of the media product being played.
	public let audioSampleRate: Int?
	/// The bit depth indicated in number of bits used per sample of the media product being played.
	public let audioBitDepth: Int?
	/// The bit rate indicated in number of bits per second of the media product being played.
	public let audioBitRate: Int?
	/// The video quality of the media product being played.
	/// - Attention: Might differ from requested in case of a replacement.
	public let videoQuality: VideoQuality?
	/// The duration, in seconds, of the media product being played.
	/// - Attention: Might differ from the meta data connected to the requested in case of a replacement.
	public let duration: Double
	/// The current position of playback, in seconds, in the current media product.
	public let assetPosition: Double
	/// The playback session id that is used for PlayLog and StreamingMetrics (streamingSessionId)
	/// for the currently active playback.
	public let playbackSessionId: String?

	/// Default initializer
	public init(
		productId: String,
		streamType: StreamType,
		assetPresentation: AssetPresentation,
		audioMode: AudioMode?,
		audioQuality: AudioQuality?,
		audioCodec: String?,
		audioSampleRate: Int?,
		audioBitDepth: Int?,
		audioBitRate: Int?,
		videoQuality: VideoQuality?,
		duration: Double,
		assetPosition: Double,
		playbackSessionId: String?
	) {
		self.productId = productId
		self.streamType = streamType
		self.assetPresentation = assetPresentation
		self.audioMode = audioMode
		self.audioQuality = audioQuality
		self.audioCodec = audioCodec
		self.audioSampleRate = audioSampleRate
		self.audioBitDepth = audioBitDepth
		self.audioBitRate = audioBitRate
		self.videoQuality = videoQuality
		self.duration = duration
		self.assetPosition = assetPosition
		self.playbackSessionId = playbackSessionId
		super.init()
	}
}
