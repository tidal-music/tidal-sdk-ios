import Foundation

struct StreamingSessionEnd: StreamingMetricsEvent {
	// MARK: - StreamingMetricsEvent

	let streamingSessionId: String
	var name: String {
		StreamingMetricNames.streamingSessionEnd
	}

	// MARK: - Other properties

	let timestamp: UInt64

	private enum CodingKeys: String, CodingKey {
		case streamingSessionId
		case timestamp
	}

	// MARK: - Initialization

	init(
		streamingSessionId: String,
		timestamp: UInt64
	) {
		self.streamingSessionId = streamingSessionId
		self.timestamp = timestamp
	}

	// MARK: - Decodable

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		streamingSessionId = try container.decode(String.self, forKey: .streamingSessionId)
		timestamp = try container.decode(UInt64.self, forKey: .timestamp)
	}

	// MARK: - Encodable

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(timestamp, forKey: .timestamp)

		try container.encode(streamingSessionId, forKey: .streamingSessionId)
	}
}
