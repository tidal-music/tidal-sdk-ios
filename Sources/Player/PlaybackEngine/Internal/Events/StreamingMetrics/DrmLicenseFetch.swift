import Foundation

struct DrmLicenseFetch: StreamingMetricsEvent {
	// MARK: - StreamingMetricsEvent

	let streamingSessionId: String
	var name: String {
		StreamingMetricNames.drmLicenseFetch
	}

	// MARK: - Other properties

	let startTimestamp: UInt64
	let endTimestamp: UInt64
	let endReason: EndReason
	var errorMessage: String?
	var errorCode: String?

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
