import Foundation
import GRDB

// MARK: - EventPersistentObject

struct EventPersistentObject: Codable, Identifiable, FetchableRecord, PersistableRecord {
	enum CodingKeys: String, CodingKey {
		case id = "rowid"
		case name
		case headers
		case payload
		case consentCategory
	}

	static let databaseTableName = "events"
	static let columnID = "rowid"
	static let columnName = "name"
	static let columnConsentCategory = "consentCategory"
	static let columnPayload = "payload"
	static let columnHeaders = "headers"

	var id: String
	var name: String
	var headers: [String: String]
	var payload: String
	var consentCategory: ConsentCategory

	init(
		id: String = UUID().uuidString,
		name: String,
		headers: [String: String] = [:],
		payload: String,
		consentCategory: ConsentCategory
	) {
		self.id = id
		self.name = name
		self.headers = headers
		self.payload = payload
		self.consentCategory = consentCategory
	}
}

extension EventPersistentObject {
	func toEvent() -> Event {
		Event(
			id: id,
			name: name,
			headers: headers,
			payload: payload
		)
	}
}
