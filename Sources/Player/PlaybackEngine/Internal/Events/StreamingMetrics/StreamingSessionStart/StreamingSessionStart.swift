import Foundation

struct StreamingSessionStart: StreamingMetricsEvent {
	enum SessionTag: String, Codable {
		case PRELOADED
		case CACHING_DISABLED
	}

	// MARK: - StreamingMetricsEvent

	let streamingSessionId: String
	var name: String {
		StreamingMetricNames.streamingSessionStart
	}

	// MARK: - Other properties

	let timestamp: UInt64
	let isOfflineModeStart: Bool = false
	let startReason: StartReason
	let hardwarePlatform: String
	let operatingSystem: String
	let operatingSystemVersion: String
	let networkType: String
	let mobileNetworkType: String
	let screenWidth: Int
	let screenHeight: Int
	let outputDevice: String?
	let sessionType: SessionType
	let sessionProductType: String
	let sessionProductId: String
	let sessionTags: [SessionTag]?

	private enum CodingKeys: String, CodingKey {
		case streamingSessionId
		case timestamp
		case isOfflineModeStart
		case startReason
		case hardwarePlatform
		case operatingSystem
		case operatingSystemVersion
		case networkType
		case mobileNetworkType
		case screenHeight
		case screenWidth
		case outputDevice
		case sessionType
		case sessionProductType
		case sessionProductId
		case sessionTags
	}

	init(
		streamingSessionId: String,
		startReason: StartReason,
		timestamp: UInt64,
		networkType: NetworkType,
		outputDevice: String?,
		sessionType: SessionType,
		sessionProductType: String,
		sessionProductId: String,
		sessionTags: [SessionTag]? = nil
	) {
		self.streamingSessionId = streamingSessionId
		self.startReason = startReason
		self.timestamp = timestamp
		self.networkType = networkType.rawValue
		self.outputDevice = outputDevice
		self.sessionType = sessionType
		hardwarePlatform = PlayerWorld.deviceInfoProvider.hardwarePlatform
		operatingSystem = PlayerWorld.deviceInfoProvider.operatingSystem
		operatingSystemVersion = PlayerWorld.deviceInfoProvider.operatingSystemVersion
		screenWidth = PlayerWorld.deviceInfoProvider.screenWidth()
		screenHeight = PlayerWorld.deviceInfoProvider.screenHeight()
		mobileNetworkType = PlayerWorld.deviceInfoProvider.mobileNetworkType(networkType)
		self.sessionProductType = sessionProductType
		self.sessionProductId = sessionProductId
		self.sessionTags = sessionTags
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(timestamp, forKey: .timestamp)
		try container.encode(isOfflineModeStart, forKey: .isOfflineModeStart)
		try container.encode(startReason, forKey: .startReason)
		try container.encode(hardwarePlatform, forKey: .hardwarePlatform)
		try container.encode(operatingSystem, forKey: .operatingSystem)
		try container.encode(operatingSystemVersion, forKey: .operatingSystemVersion)
		try container.encode(networkType, forKey: .networkType)
		try container.encode(mobileNetworkType, forKey: .mobileNetworkType)
		try container.encode(screenWidth, forKey: .screenWidth)
		try container.encode(screenHeight, forKey: .screenHeight)
		try container.encode(outputDevice, forKey: .outputDevice)
		try container.encode(sessionType, forKey: .sessionType)
		try container.encode(sessionProductType, forKey: .sessionProductType)
		try container.encode(sessionProductId, forKey: .sessionProductId)
		try container.encode(streamingSessionId, forKey: .streamingSessionId)
		try container.encode(sessionTags, forKey: .sessionTags)
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		streamingSessionId = try container.decode(String.self, forKey: .streamingSessionId)
		timestamp = try container.decode(UInt64.self, forKey: .timestamp)
		startReason = try container.decode(StartReason.self, forKey: .startReason)
		hardwarePlatform = try container.decode(String.self, forKey: .hardwarePlatform)
		operatingSystem = try container.decode(String.self, forKey: .operatingSystem)
		operatingSystemVersion = try container.decode(String.self, forKey: .operatingSystemVersion)
		networkType = try container.decode(String.self, forKey: .networkType)
		mobileNetworkType = try container.decode(String.self, forKey: .mobileNetworkType)
		screenWidth = try container.decode(Int.self, forKey: .screenWidth)
		screenHeight = try container.decode(Int.self, forKey: .screenHeight)
		outputDevice = try container.decode(String?.self, forKey: .outputDevice)
		sessionType = try container.decode(SessionType.self, forKey: .sessionType)
		sessionProductType = try container.decode(String.self, forKey: .sessionProductType)
		sessionProductId = try container.decode(String.self, forKey: .sessionProductId)
		sessionTags = try container.decodeIfPresent([SessionTag].self, forKey: .sessionTags)
	}
}
