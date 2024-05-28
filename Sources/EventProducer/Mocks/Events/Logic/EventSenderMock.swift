import Combine
import Foundation

// MARK: - EventSenderMock

public final class EventSenderMock {
	public struct Event: Equatable {
		public let name: String
		public let consentCategory: ConsentCategory
		public let headers: [String: String]
		public let payload: String

		public init(
			name: String,
			consentCategory: ConsentCategory,
			headers: [String: String],
			payload: String
		) {
			self.name = name
			self.consentCategory = consentCategory
			self.headers = headers
			self.payload = payload
		}
	}

	public private(set) var sentEvents: [Event] = []

	public init() {}
}

// MARK: EventSender

extension EventSenderMock: EventSender {
	public func sendEvent(
		name: String,
		consentCategory: ConsentCategory,
		headers: [String: String] = [:],
		payload: String
	) async throws {
		let event = Event(name: name, consentCategory: consentCategory, headers: headers, payload: payload)
		sentEvents.append(event)
	}
}
