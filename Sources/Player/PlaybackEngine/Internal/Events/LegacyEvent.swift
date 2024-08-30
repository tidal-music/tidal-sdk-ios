import Foundation

// MARK: - LegacyEvent

final class LegacyEvent<T: Codable & Equatable>: Codable {
	let group: String
	let name: String
	let version: Int
	let ts: UInt64
	let uuid: String
	let user: User
	let client: Client
	let payload: T
	let extras: [String: String?]?

	init(group: String, name: String, version: Int, ts: UInt64, user: User, client: Client, payload: T, extras: [String: String?]?) {
		self.group = group
		self.name = name
		self.version = version
		self.ts = ts
		uuid = PlayerWorld.uuidProvider.uuidString()
		self.user = user
		self.client = client
		self.payload = payload
		self.extras = extras
	}
}

// MARK: Equatable

extension LegacyEvent: Equatable {
	static func == (lhs: LegacyEvent<T>, rhs: LegacyEvent<T>) -> Bool {
		lhs.group == rhs.group &&
			lhs.name == rhs.name &&
			lhs.version == rhs.version &&
			lhs.ts == rhs.ts &&
			lhs.uuid == rhs.uuid &&
			lhs.user == rhs.user &&
			lhs.client == rhs.client &&
			lhs.payload == rhs.payload &&
			lhs.extras == rhs.extras
	}
}
