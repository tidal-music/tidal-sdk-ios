import Foundation

// MARK: - MonitoringInfo

public struct MonitoringInfo: Codable {
	public static let databaseId = "monitoring_id"

	var id: String = databaseId
	var consentFilteredEvents: [String: Int]
	var validationFailedEvents: [String: Int]
	var storingFailedEvents: [String: Int]

	public init(
		id: String = databaseId,
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

// MARK: Equatable

extension MonitoringInfo: Equatable {
	public static func == (lhs: MonitoringInfo, rhs: MonitoringInfo) -> Bool {
		lhs.id == rhs.id &&
			lhs.consentFilteredEvents == rhs.consentFilteredEvents &&
			lhs.validationFailedEvents == rhs.validationFailedEvents &&
			lhs.storingFailedEvents == rhs.storingFailedEvents
	}
}

public extension MonitoringInfo {
	func toMonitoringInfoPersistentObject() -> MonitoringInfoPersistentObject {
		MonitoringInfoPersistentObject(
			id: id,
			consentFilteredEvents: consentFilteredEvents,
			validationFailedEvents: validationFailedEvents,
			storingFailedEvents: storingFailedEvents
		)
	}
}
