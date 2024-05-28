@testable import Player

extension StreamingSessionEnd {
	static func mock(
		streamingSessionId: String = "uuid",
		timestamp: UInt64 = 1
	) -> Self {
		StreamingSessionEnd(streamingSessionId: streamingSessionId, timestamp: timestamp)
	}
}
