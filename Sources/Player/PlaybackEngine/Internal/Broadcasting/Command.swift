import Foundation

struct Command: Encodable {
	private let type: String
	private let assetId: String?
	private let assetPositionMillis: UInt64?
	private let timestampEpochMillis: UInt64?

	private init(_ type: String, _ assetId: String?, _ assetPositionMillis: UInt64?, _ timestampEpochMillis: UInt64?) {
		self.type = type
		self.assetId = assetId
		self.assetPositionMillis = assetPositionMillis
		self.timestampEpochMillis = timestampEpochMillis
	}

	static func play(_ assetId: String, at position: UInt64, timestamp: UInt64) -> Command {
		Command("PLAY", assetId, position, timestamp)
	}

	static func pause(_ assetId: String, timestamp: UInt64) -> Command {
		Command("PAUSE", assetId, nil, timestamp)
	}
}
