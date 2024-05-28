import Foundation
import GRDB

// MARK: - MonitoringInfoPersistentObject

public struct MonitoringInfoPersistentObject: Codable, Identifiable, FetchableRecord, PersistableRecord {
	enum CodingKeys: String, CodingKey {
		case id = "rowid"
		case consentFilteredEvents
		case validationFailedEvents
		case storingFailedEvents
	}

	public static let databaseTableName = "monitoring"
	public static let databaseId = "monitoring_id"
	static let columnId = "rowid"
	static let columnConsentFilteredEvents = "consentFilteredEvents"
	static let columnValidationFailedEvents = "validationFailedEvents"
	static let columnStoringFailedEvents = "storingFailedEvents"

	public let id: String
	public var consentFilteredEvents: [String: Int]
	public var validationFailedEvents: [String: Int]
	public var storingFailedEvents: [String: Int]

	public init(
		id: String,
		consentFilteredEvents: [String: Int],
		validationFailedEvents: [String: Int],
		storingFailedEvents: [String: Int]
	) {
		self.id = id
		self.consentFilteredEvents = consentFilteredEvents
		self.validationFailedEvents = validationFailedEvents
		self.storingFailedEvents = storingFailedEvents
	}
}

public extension MonitoringInfoPersistentObject {
	func toMonitoringInfo() -> MonitoringInfo {
		MonitoringInfo(
			id: id,
			consentFilteredEvents: consentFilteredEvents,
			validationFailedEvents: validationFailedEvents,
			storingFailedEvents: storingFailedEvents
		)
	}
}
