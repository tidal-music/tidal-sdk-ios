import Foundation

// MARK: - PlaybackStatistics

struct PlaybackStatistics: StreamingMetricsEvent {
	// MARK: - StreamingMetricsEvent

	let streamingSessionId: String
	var name: String {
		StreamingMetricNames.playbackStatistics
	}

	// MARK: - Other properties

	// Attention: If you add new properties, please update the Equatable conformance below.

	let idealStartTimestamp: UInt64?
	let actualStartTimestamp: UInt64?
	let hasAds: Bool = false
	let productType: String
	let actualProductId: String
	let actualStreamType: String
	let actualAssetPresentation: String
	let actualAudioMode: String?
	let actualQuality: String
	let cdm: String = "FAIRPLAY"
	let cdmVersion: String = "N/A"
	let stalls: [Stall]
	let startReason: StartReason
	let endReason: String
	let endTimestamp: UInt64
	let sessionTags: [SessionTag]?

	/// - Attention: This property is ignored in Equatable conformance.
	let errorMessage: String?
	let errorCode: String?

	private enum CodingKeys: String, CodingKey {
		case streamingSessionId
		case idealStartTimestamp
		case actualStartTimestamp
		case hasAds
		case productType
		case actualProductId
		case actualStreamType
		case actualAssetPresentation
		case actualAudioMode
		case actualQuality
		case cdm
		case cdmVersion
		case stalls
		case startReason
		case endReason
		case endTimestamp
		case sessionTags
		case errorMessage
		case errorCode
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(idealStartTimestamp, forKey: .idealStartTimestamp)
		try container.encode(actualStartTimestamp, forKey: .actualStartTimestamp)
		try container.encode(hasAds, forKey: .hasAds)
		try container.encode(productType, forKey: .productType)
		try container.encode(actualProductId, forKey: .actualProductId)
		try container.encode(actualStreamType, forKey: .actualStreamType)
		try container.encode(actualAssetPresentation, forKey: .actualAssetPresentation)
		try container.encode(actualAudioMode, forKey: .actualAudioMode)
		try container.encode(actualQuality, forKey: .actualQuality)
		try container.encode(cdm, forKey: .cdm)
		try container.encode(stalls, forKey: .stalls)
		try container.encode(startReason, forKey: .startReason)
		try container.encode(endReason, forKey: .endReason)
		try container.encode(endTimestamp, forKey: .endTimestamp)
		try container.encode(sessionTags, forKey: .sessionTags)
		try container.encode(errorMessage, forKey: .errorMessage)
		try container.encode(errorCode, forKey: .errorCode)
		try container.encode(streamingSessionId, forKey: .streamingSessionId)
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		idealStartTimestamp = try container.decode(UInt64?.self, forKey: .idealStartTimestamp)
		actualStartTimestamp = try container.decode(UInt64?.self, forKey: .actualStartTimestamp)
		productType = try container.decode(String.self, forKey: .productType)
		actualProductId = try container.decode(String.self, forKey: .actualProductId)
		actualStreamType = try container.decode(String.self, forKey: .actualStreamType)
		actualAssetPresentation = try container.decode(String.self, forKey: .actualAssetPresentation)
		actualAudioMode = try container.decode(String?.self, forKey: .actualAudioMode)
		actualQuality = try container.decode(String.self, forKey: .actualQuality)
		stalls = try container.decode([Stall].self, forKey: .stalls)
		startReason = try container.decode(StartReason.self, forKey: .startReason)
		endReason = try container.decode(String.self, forKey: .endReason)
		endTimestamp = try container.decode(UInt64.self, forKey: .endTimestamp)
		sessionTags = try container.decodeIfPresent([SessionTag].self, forKey: .sessionTags)
		errorMessage = try container.decode(String?.self, forKey: .errorMessage)
		errorCode = try container.decode(String?.self, forKey: .errorCode)
		streamingSessionId = try container.decode(String.self, forKey: .streamingSessionId)
	}

	init(
		streamingSessionId: String,
		idealStartTimestamp: UInt64?,
		actualStartTimestamp: UInt64?,
		productType: String,
		actualProductId: String,
		actualStreamType: String,
		actualAssetPresentation: String,
		actualAudioMode: String?,
		actualQuality: String,
		stalls: [Stall],
		startReason: StartReason,
		endReason: String,
		endTimestamp: UInt64,
		sessionTags: [SessionTag]? = nil,
		errorMessage: String?,
		errorCode: String?
	) {
		self.streamingSessionId = streamingSessionId
		self.idealStartTimestamp = idealStartTimestamp
		self.actualStartTimestamp = actualStartTimestamp
		self.productType = productType
		self.actualProductId = actualProductId
		self.actualStreamType = actualStreamType
		self.actualAssetPresentation = actualAssetPresentation
		self.actualAudioMode = actualAudioMode
		self.actualQuality = actualQuality
		self.stalls = stalls
		self.startReason = startReason
		self.endReason = endReason
		self.endTimestamp = endTimestamp
		self.sessionTags = sessionTags
		self.errorMessage = errorMessage
		self.errorCode = errorCode
	}
}

// MARK: Equatable

extension PlaybackStatistics: Equatable {
	static func == (lhs: PlaybackStatistics, rhs: PlaybackStatistics) -> Bool {
		// We ignore `errorMessage` since it can contain UUIDs which we can't use for assertion, so we only make sure the error code is
		// the same.
		guard lhs.errorMessage == nil && rhs.errorMessage == nil ||
			lhs.errorMessage != nil && rhs.errorMessage != nil
		else {
			return false
		}

		return lhs.streamingSessionId == rhs.streamingSessionId &&
			lhs.idealStartTimestamp == rhs.idealStartTimestamp &&
			lhs.actualStartTimestamp == rhs.actualStartTimestamp &&
			lhs.hasAds == rhs.hasAds &&
			lhs.productType == rhs.productType &&
			lhs.actualProductId == rhs.actualProductId &&
			lhs.actualStreamType == rhs.actualStreamType &&
			lhs.actualAssetPresentation == rhs.actualAssetPresentation &&
			lhs.actualAudioMode == rhs.actualAudioMode &&
			lhs.actualQuality == rhs.actualQuality &&
			lhs.cdm == rhs.cdm &&
			lhs.cdmVersion == rhs.cdmVersion &&
			lhs.stalls == rhs.stalls &&
			lhs.startReason == rhs.startReason &&
			lhs.endReason == rhs.endReason &&
			lhs.endTimestamp == rhs.endTimestamp &&
			lhs.sessionTags == rhs.sessionTags &&
			lhs.errorCode == rhs.errorCode
	}
}
