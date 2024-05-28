@testable import Player

extension DrmLicenseFetch {
	static func mock(
		streamingSessionId: String = "streamingSessionId",
		startTimestamp: UInt64 = 1,
		endTimestamp: UInt64 = 2,
		endReason: EndReason = .COMPLETE,
		errorMessage: String? = nil,
		errorCode: String? = nil
	) -> Self {
		DrmLicenseFetch(
			streamingSessionId: streamingSessionId,
			startTimestamp: startTimestamp,
			endTimestamp: endTimestamp,
			endReason: endReason,
			errorMessage: errorMessage,
			errorCode: errorCode
		)
	}
}
