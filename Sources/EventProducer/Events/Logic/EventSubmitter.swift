import Foundation

final class EventSubmitter {
	public static let shared = EventSubmitter()

	private let eventsQueue: EventQueue
	private let monitoring: Monitoring
	private let fileManager: FileManagerHelper

	private init(
		eventsQueue: EventQueue = .shared,
		monitoring: Monitoring = .shared,
		fileManager: FileManagerHelper = .shared
	) {
		self.eventsQueue = eventsQueue
		self.monitoring = monitoring
		self.fileManager = fileManager
	}

	/// Submits the event to the Queue.
	/// - Parameters:
	///   - name: Defines a certain type of event. E.g. "play-log".
	///   - consentCategory: The consent category the event belongs to
	///   - headers: Headers containing metadata attached to the payload.
	///   - payload: Contains business information the app wants to send.
	func sendEvent(
		name: String,
		consentCategory: ConsentCategory,
		headers: [String: String],
		payload: String
	) async throws {
		guard fileManager.isDiskSpaceAvailable else {
			try await monitoring.updateMonitoringEvent(monitoringEventType: .failedStorage, eventName: name)
			return
		}

		let event = Event(
			name: name,
			headers: headers,
			payload: payload
		)
		return try await eventsQueue.addEvent(event: event, consentCategory: consentCategory)
	}
}
