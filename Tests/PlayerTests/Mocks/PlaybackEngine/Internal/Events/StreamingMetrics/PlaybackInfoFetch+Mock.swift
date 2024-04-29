@testable import Player

extension PlaybackInfoFetch {
	static func mock(
		streamingSessionId: String = "uuid",
		startTimestamp: UInt64 = 1,
		endTimestamp: UInt64 = 2,
		endReason: EndReason = .COMPLETE,
		errorMessage: String? = nil,
		errorCode: String? = nil
	) -> Self {
		PlaybackInfoFetch(
			streamingSessionId: streamingSessionId,
			startTimestamp: startTimestamp,
			endTimestamp: endTimestamp,
			endReason: endReason,
			errorMessage: errorMessage,
			errorCode: errorCode
		)
	}
}
