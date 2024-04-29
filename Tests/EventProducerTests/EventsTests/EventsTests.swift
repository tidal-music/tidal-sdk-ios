import Common
@testable import EventProducer
import XCTest

final class EventsTests: XCTestCase {
	private struct MockAuthProvider: AuthProvider {
		let token: String?
		let clientID: String?
		func refreshAccessToken(status: Int?) {}
		func getToken() async -> String? {
			token
		}
	}

	private var sender = EventSenderClient.shared
	private let queue = EventQueue.shared
	private var headerHelper: HeaderHelper!
	private let maxDiskUsageBytes = 20480

	override func setUp() async throws {
		try await super.setUp()
		headerHelper = HeaderHelper(auth: mockAuthProvider)
		try await queue.deleteAllEvents()
	}

	private var mockAuthProvider: AuthProvider {
		MockAuthProvider(token: "testAccessToken", clientID: "testURL")
	}

	func testSendEvent() async throws {
		sender.setupConfiguration(config: .init(authProvider: mockAuthProvider, maxDiskUsageBytes: maxDiskUsageBytes))

		try await sender.sendEvent(
			name: "testEvent",
			consentCategory: .necessary,
			payload: "testPayload"
		)

		let tokenToTest = await sender.config?.authProvider.getToken()
		XCTAssertEqual(tokenToTest, "testAccessToken")
	}

	func testSendEventFailsWhenConfigurationNotCalled() async {
		do {
			try await sender.sendEvent(
				name: "testEvent",
				consentCategory: .necessary,
				payload: "testPayload"
			)
		} catch {
			XCTAssertNotNil(error)
			guard let error = error as? EventProducerError else {
				XCTFail("Wrong exception type")
				return
			}

			guard case let .genericError(message) = error else {
				return
			}
			XCTAssertEqual(message, "EventSenderConfig not setup, you must call setupConfiguration() before calling sendEvent")
		}
	}

	func testEventSenderConfig() async {
		let mockAuthProvider = MockAuthProvider(token: "token123", clientID: "clientId123")

		let initialConfig = EventSenderConfig(
			consumerUri: "initialConsumerUri",
			authProvider: mockAuthProvider,
			maxDiskUsageBytes: 1024
		)

		sender.setupConfiguration(config: initialConfig)
		var tokenToTest = await sender.config?.authProvider.getToken()
		XCTAssertEqual(tokenToTest, "token123")
		XCTAssertEqual(sender.config?.consumerUri, "initialConsumerUri")
		XCTAssertEqual(sender.config?.maxDiskUsageBytes, 1024)

		let updatedConfig = EventSenderConfig(
			consumerUri: "updatedConsumerUri",
			authProvider: mockAuthProvider,
			maxDiskUsageBytes: 5000
		)

		sender.setupConfiguration(config: updatedConfig)
		tokenToTest = await sender.config?.authProvider.getToken()
		XCTAssertEqual(tokenToTest, "token123")
		XCTAssertEqual(sender.config?.consumerUri, "updatedConsumerUri")
		XCTAssertEqual(sender.config?.maxDiskUsageBytes, 5000)
	}

	func testEventsPersisted() async throws {
		sender.setupConfiguration(config: .init(authProvider: mockAuthProvider, maxDiskUsageBytes: maxDiskUsageBytes))

		let event1 = Event(
			name: "testEvent#1",
			payload: "firstPayload"
		)

		let event2 = Event(
			name: "testEvent#2",
			payload: "secondPayload"
		)

		try await queue.addEvent(event: event1, consentCategory: .performance)
		try await queue.addEvent(event: event2, consentCategory: .necessary)
		let fetchedEvents = try await queue.getAllEvents()

		XCTAssertTrue(fetchedEvents.contains(where: { $0.name == "testEvent#1" }))
		XCTAssertTrue(fetchedEvents.contains(where: { $0.name == "testEvent#2" }))
		XCTAssertFalse(fetchedEvents.contains(where: { $0.name == "fakeEvent" }))
	}

	func testSendEventThroughScheduler() async throws {
		sender.setupConfiguration(config: .init(authProvider: mockAuthProvider, maxDiskUsageBytes: maxDiskUsageBytes))

		let event = Event(
			name: "testEvent",
			payload: "payload"
		)

		try await queue.addEvent(event: event, consentCategory: .necessary)
		do {
			try await EventScheduler.shared.sendAllEvents(headerHelper: headerHelper)
			XCTFail("Auth token is invalid - it *should* fail")
		} catch {
			let leftoverEvents = try await queue.getAllEvents().count
			XCTAssertEqual(leftoverEvents, 1)
		}

		let anonymousAuthProvider = MockAuthProvider(token: nil, clientID: "42")
		headerHelper = HeaderHelper(auth: anonymousAuthProvider)
		sender.setupConfiguration(config: .init(authProvider: anonymousAuthProvider, maxDiskUsageBytes: maxDiskUsageBytes))
		try await EventScheduler.shared.sendAllEvents(headerHelper: headerHelper)
		let leftoverEvents = try await queue.getAllEvents().count
		XCTAssertEqual(leftoverEvents, 0)
	}

	func testSendEventTwoBatchesThroughScheduler() async throws {
		let anonymousAuthProvider = MockAuthProvider(token: nil, clientID: "42")
		headerHelper = HeaderHelper(auth: anonymousAuthProvider)

		sender.setupConfiguration(config: .init(authProvider: anonymousAuthProvider, maxDiskUsageBytes: maxDiskUsageBytes))

		for index in 0 ... 15 {
			let event = Event(
				name: "testEvent#\(index)",
				payload: "payload#\(index)"
			)
			try await queue.addEvent(event: event, consentCategory: .necessary)
		}

		try await EventScheduler.shared.sendAllEvents(headerHelper: headerHelper)
		let leftoverEvents = try await queue.getAllEvents().count

		XCTAssertEqual(leftoverEvents, 0)
	}

	func testBlockedConsentCategoriesEventsDropped() async throws {
		sender.setupConfiguration(
			config: .init(
				authProvider: mockAuthProvider,
				maxDiskUsageBytes: maxDiskUsageBytes,
				blockedConsentCategories: [.targeting, .performance]
			)
		)

		try await sender.sendEvent(
			name: "PerformanceEvent",
			consentCategory: .performance,
			payload: "firstPayload"
		)

		try await sender.sendEvent(
			name: "NecessaryEvent",
			consentCategory: .necessary,
			headers: ["test": "test"],
			payload: "secondPayload"
		)

		try await sender.sendEvent(
			name: "TargetingEvent",
			consentCategory: .targeting,
			payload: "firstPayload"
		)

		let fetchedEvents = try await queue.getAllEvents()

		XCTAssertEqual(fetchedEvents.count, 1)
		XCTAssertFalse(fetchedEvents.contains(where: { $0.name == "PerformanceEvent" }))
		XCTAssertTrue(fetchedEvents.contains(where: { $0.name == "NecessaryEvent" }))
		XCTAssertFalse(fetchedEvents.contains(where: { $0.name == "TargetingEvent" }))
		XCTAssertFalse(fetchedEvents.contains(where: { $0.name == "fakeEvent" }))
	}

	func testCorrectCategoryStored() async throws {
		sender.setupConfiguration(
			config: .init(
				authProvider: mockAuthProvider,
				maxDiskUsageBytes: maxDiskUsageBytes,
				blockedConsentCategories: []
			)
		)

		try await sender.sendEvent(
			name: "PerformanceEvent",
			consentCategory: .performance,
			headers: [HTTPHeaderKeys.consentCategory.rawValue: ConsentCategory.performance.rawValue],
			payload: "firstPayload"
		)

		try await sender.sendEvent(
			name: "NecessaryEvent",
			consentCategory: .necessary,
			headers: ["test": "test", HTTPHeaderKeys.consentCategory.rawValue: ConsentCategory.necessary.rawValue],
			payload: "secondPayload"
		)

		try await sender.sendEvent(
			name: "TargetingEvent",
			consentCategory: .targeting,
			headers: [HTTPHeaderKeys.consentCategory.rawValue: ConsentCategory.targeting.rawValue],
			payload: "firstPayload"
		)

		let fetchedEvents = try await queue.getAllEvents()

		XCTAssertEqual(fetchedEvents.count, 3)
		XCTAssertEqual(
			fetchedEvents.filter { $0.headers[HTTPHeaderKeys.consentCategory.rawValue] == ConsentCategory.performance.rawValue }
				.count,
			1
		)
		XCTAssertEqual(
			fetchedEvents.filter { $0.headers[HTTPHeaderKeys.consentCategory.rawValue] == ConsentCategory.necessary.rawValue }.count,
			1
		)
		XCTAssertEqual(
			fetchedEvents.filter { $0.headers[HTTPHeaderKeys.consentCategory.rawValue] == ConsentCategory.targeting.rawValue }.count,
			1
		)
	}
}
