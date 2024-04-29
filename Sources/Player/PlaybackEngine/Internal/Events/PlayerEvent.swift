import EventProducer

// MARK: - PlayerEvent

final class PlayerEvent<T: Codable & Equatable>: Codable {
	let group: String
	let version: Int
	let ts: UInt64
	let uuid: String
	let user: User
	let client: Client
	let payload: T

	init(group: String, version: Int, ts: UInt64, user: User, client: Client, payload: T) {
		self.group = group
		self.version = version
		self.ts = ts
		uuid = PlayerWorld.uuidProvider.uuidString()
		self.user = user
		self.client = client
		self.payload = payload
	}
}

// MARK: Equatable

extension PlayerEvent: Equatable {
	static func == (lhs: PlayerEvent<T>, rhs: PlayerEvent<T>) -> Bool {
		lhs.group == rhs.group &&
			lhs.version == rhs.version &&
			lhs.ts == rhs.ts &&
			lhs.uuid == rhs.uuid &&
			lhs.user == rhs.user &&
			lhs.client == rhs.client &&
			lhs.payload == rhs.payload
	}
}
