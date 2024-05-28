@testable import Player

extension DownloadStatistics {
	static func mock(
		streamingSessionId: String = "streamingSessionId",
		startTimestamp: UInt64 = 1,
		productType: String = "productType",
		actualProductId: String = "actualProductId",
		actualAssetPresentation: String = "actualAssetPresentation",
		actualAudioMode: String? = nil,
		actualQuality: String = "actualQuality",
		endReason: String = "endReason",
		endTimestamp: UInt64 = 2,
		errorMessage: String? = nil,
		errorCode: String? = nil
	) -> Self {
		DownloadStatistics(
			streamingSessionId: streamingSessionId,
			startTimestamp: startTimestamp,
			productType: productType,
			actualProductId: actualProductId,
			actualAssetPresentation: actualAssetPresentation,
			actualAudioMode: actualAudioMode,
			actualQuality: actualQuality,
			endReason: endReason,
			endTimestamp: endTimestamp,
			errorMessage: errorMessage,
			errorCode: errorCode
		)
	}
}
