@testable import Player

extension PlaybackStatistics {
	static func mock(
		streamingSessionId: String = "uuid",
		idealStartTimestamp: UInt64? = nil,
		actualStartTimestamp: UInt64? = nil,
		productType: String = ProductType.TRACK.rawValue,
		actualProductId: String = "actualProductId",
		actualStreamType: String = StreamType.ON_DEMAND.rawValue,
		actualAssetPresentation: String = AssetPresentation.FULL.rawValue,
		actualAudioMode: String? = AudioMode.STEREO.rawValue,
		actualQuality: String = AudioQuality.LOSSLESS.rawValue,
		stalls: [Stall] = [],
		startReason: StartReason = StartReason.EXPLICIT,
		endReason: String = EndReason.COMPLETE.rawValue,
		endTimestamp: UInt64 = 1,
		tags: [PlaybackStatistics.EventTag] = [],
		errorMessage: String? = nil,
		errorCode: String? = nil
	) -> Self {
		PlaybackStatistics(
			streamingSessionId: streamingSessionId,
			idealStartTimestamp: idealStartTimestamp,
			actualStartTimestamp: actualStartTimestamp,
			productType: productType,
			actualProductId: actualProductId,
			actualStreamType: actualStreamType,
			actualAssetPresentation: actualAssetPresentation,
			actualAudioMode: actualAudioMode,
			actualQuality: actualQuality,
			stalls: stalls,
			startReason: startReason,
			endReason: endReason,
			endTimestamp: endTimestamp,
			tags: tags,
			errorMessage: errorMessage,
			errorCode: errorCode
		)
	}
}
