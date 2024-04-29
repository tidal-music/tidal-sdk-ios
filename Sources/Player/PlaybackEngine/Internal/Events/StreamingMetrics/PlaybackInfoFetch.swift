import Foundation

// MARK: - PlaybackInfoFetch

struct PlaybackInfoFetch: StreamingMetricsEvent {
	// MARK: - StreamingMetricsEvent

	let streamingSessionId: String
	var name: String {
		StreamingMetricNames.playbackInfoFetch
	}

	// MARK: - Other properties

	// Attention: If you add new properties, please update the Equatable conformance below.

	let startTimestamp: UInt64
	let endTimestamp: UInt64
	let endReason: EndReason
	/// - Attention: This property is ignored in Equatable conformance.
	let errorMessage: String?
	let errorCode: String?

	private enum CodingKeys: String, CodingKey {
		case streamingSessionId
		case startTimestamp
		case endTimestamp
		case endReason
		case errorMessage
		case errorCode
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(startTimestamp, forKey: .startTimestamp)
		try container.encode(endTimestamp, forKey: .endTimestamp)
		try container.encode(endReason.rawValue, forKey: .endReason)
		try container.encode(errorMessage, forKey: .errorMessage)
		try container.encode(errorCode, forKey: .errorCode)
		try container.encode(streamingSessionId, forKey: .streamingSessionId)
	}
}

// MARK: Equatable

extension PlaybackInfoFetch: Equatable {
	static func == (lhs: PlaybackInfoFetch, rhs: PlaybackInfoFetch) -> Bool {
		// We ignore `errorMessage` since it can contain UUIDs which we can't use for assertion, so we only make sure the error code is
		// the same.
		guard lhs.errorMessage == nil && rhs.errorMessage == nil ||
			lhs.errorMessage != nil && rhs.errorMessage != nil
		else {
			return false
		}

		return lhs.streamingSessionId == rhs.streamingSessionId &&
			lhs.name == rhs.name &&
			lhs.startTimestamp == rhs.startTimestamp &&
			lhs.endTimestamp == rhs.endTimestamp &&
			lhs.endReason == rhs.endReason &&
			lhs.errorCode == rhs.errorCode
	}
}
