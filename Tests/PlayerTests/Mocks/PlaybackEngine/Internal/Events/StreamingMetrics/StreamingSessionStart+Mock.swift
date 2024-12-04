@testable import Player

extension StreamingSessionStart {
	static func mock(
		streamingSessionId: String = "uuid",
		startReason: StartReason = .EXPLICIT,
		timestamp: UInt64 = 1,
		networkType: NetworkType = .WIFI,
		outputDevice: String? = "outputPortName",
		sessionType: SessionType = .PLAYBACK,
		sessionProductType: ProductType = .TRACK,
		sessionProductId: String = "productId",
		sessionTags: [SessionTag]? = [StreamingSessionStart.SessionTag.CACHING_V2]
	) -> Self {
		StreamingSessionStart(
			streamingSessionId: streamingSessionId,
			startReason: startReason,
			timestamp: timestamp,
			networkType: networkType,
			outputDevice: outputDevice,
			sessionType: sessionType,
			sessionProductType: sessionProductType.rawValue,
			sessionProductId: sessionProductId,
			sessionTags: sessionTags
		)
	}
}
