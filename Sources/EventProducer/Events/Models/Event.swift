import Foundation

// MARK: - Event

public struct Event: Codable {
	public var id: String
	public var name: String
	public var headers: [String: String]
	public var payload: String

	public init(
		id: String = UUID().uuidString,
		name: String,
		headers: [String: String] = [:],
		payload: String
	) {
		self.id = id
		self.name = name
		self.headers = headers
		self.payload = payload
	}
}

extension Event {
	func toEventPersistentObject(consentCategory: ConsentCategory) -> EventPersistentObject {
		EventPersistentObject(
			id: id,
			name: name,
			headers: headers,
			payload: payload,
			consentCategory: consentCategory
		)
	}
}
