import Foundation

// MARK: - DownloadStatistics

struct DownloadStatistics: StreamingMetricsEvent {
	// MARK: - StreamingMetricsEvent

	let streamingSessionId: String
	var name: String {
		StreamingMetricNames.downloadStatistics
	}

	// MARK: - Other properties

	// Attention: If you add new properties, please update the Equatable conformance below.

	let startTimestamp: UInt64
	let productType: String
	let actualProductId: String
	let actualAssetPresentation: String
	let actualAudioMode: String?
	let actualQuality: String
	let endReason: String
	let endTimestamp: UInt64
	/// - Attention: This property is ignored in Equatable conformance.
	let errorMessage: String?
	let errorCode: String?

	private enum CodingKeys: String, CodingKey {
		case streamingSessionId
		case startTimestamp
		case productType
		case actualProductId
		case actualAssetPresentation
		case actualAudioMode
		case actualQuality
		case endReason
		case endTimestamp
		case errorMessage
		case errorCode
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(startTimestamp, forKey: .startTimestamp)
		try container.encode(productType, forKey: .productType)
		try container.encode(actualProductId, forKey: .actualProductId)
		try container.encode(actualAssetPresentation, forKey: .actualAssetPresentation)
		try container.encode(actualAudioMode, forKey: .actualAudioMode)
		try container.encode(actualQuality, forKey: .actualQuality)
		try container.encode(endReason, forKey: .endReason)
		try container.encode(endTimestamp, forKey: .endTimestamp)
		try container.encode(errorMessage, forKey: .errorMessage)
		try container.encode(errorCode, forKey: .errorCode)

		try container.encode(streamingSessionId, forKey: .streamingSessionId)
	}
}

// MARK: Equatable

extension DownloadStatistics: Equatable {
	static func == (lhs: DownloadStatistics, rhs: DownloadStatistics) -> Bool {
		// We ignore `errorMessage` since it can contain UUIDs which we can't use for assertion, so we only make sure the error code is
		// the same.
		guard lhs.errorMessage == nil && rhs.errorMessage == nil ||
			lhs.errorMessage != nil && rhs.errorMessage != nil
		else {
			return false
		}

		return lhs.streamingSessionId == rhs.streamingSessionId &&
			lhs.startTimestamp == rhs.startTimestamp &&
			lhs.productType == rhs.productType &&
			lhs.actualProductId == rhs.actualProductId &&
			lhs.actualAssetPresentation == rhs.actualAssetPresentation &&
			lhs.actualAudioMode == rhs.actualAudioMode &&
			lhs.actualQuality == rhs.actualQuality &&
			lhs.endReason == rhs.endReason &&
			lhs.endTimestamp == rhs.endTimestamp &&
			lhs.errorCode == rhs.errorCode
	}
}
