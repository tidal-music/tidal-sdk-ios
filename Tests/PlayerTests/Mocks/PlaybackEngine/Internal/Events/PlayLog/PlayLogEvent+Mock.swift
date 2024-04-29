@testable import Player

extension PlayLogEvent {
	static func mock(
		playbackSessionId: String = "uuid",
		startTimestamp: UInt64 = 1,
		startAssetPosition: Double = 0,
		isPostPaywall: Bool = true,
		productType: ProductType = .TRACK,
		requestedProductId: String = "requestedProductId",
		actualProductId: String = "actualProductId",
		actualAssetPresentation: AssetPresentation = .FULL,
		actualAudioMode: AudioMode? = .STEREO,
		actualQuality: String = "actualQuality",
		sourceType: String? = nil,
		sourceId: String? = nil,
		actions: [Action] = [],
		endTimestamp: UInt64 = 2,
		endAssetPosition: Double = 2
	) -> Self {
		PlayLogEvent(
			playbackSessionId: playbackSessionId,
			startTimestamp: startTimestamp,
			startAssetPosition: startAssetPosition,
			isPostPaywall: isPostPaywall,
			productType: productType,
			requestedProductId: requestedProductId,
			actualProductId: actualProductId,
			actualAssetPresentation: actualAssetPresentation,
			actualAudioMode: actualAudioMode,
			actualQuality: actualQuality,
			sourceType: sourceType,
			sourceId: sourceId,
			actions: actions,
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
	}
}
