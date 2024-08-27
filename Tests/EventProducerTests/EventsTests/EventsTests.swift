import Common
@testable import EventProducer
@testable import Auth
import XCTest

final class EventsTests: XCTestCase {
	private struct MockCredentialsProvider: CredentialsProvider {
		let testToken: String?
		func getCredentials(apiErrorSubStatus: String?) async throws -> Credentials {
			return Credentials(
				clientId: "",
				requestedScopes: .init(),
				clientUniqueKey: "",
				grantedScopes: .init(),
				userId: "testUserId",
				expires: nil,
				token: testToken
			)
		}
		var isUserLoggedIn: Bool
	}
	
	private var eventSender = TidalEventSender.shared
	private let testAccessToken = "testAccessToken"
	private let queue = EventQueue()
	private let monitoring = Monitoring(monitoringQueue: .init())
	private var headerHelper: HeaderHelper!
	private let maxDiskUsageBytes = 204800

	override func setUp() async throws {
		try await super.setUp()
		headerHelper = HeaderHelper(credentialsProvider: mockCredentialsProvider(withToken: testAccessToken))
		eventSender.config(
			EventConfig(
			credentialsProvider: mockCredentialsProvider(withToken: testAccessToken),
			maxDiskUsageBytes: maxDiskUsageBytes
		))
		try await queue.deleteAllEvents()
	}

	private func mockCredentialsProvider(withToken token: String) -> CredentialsProvider {
		MockCredentialsProvider(testToken: token, isUserLoggedIn: true)
	}
	
	func testSendEvent() async throws {
		try await eventSender.sendEvent(
			name: "testEvent",
			consentCategory: .necessary,
			payload: "testPayload"
		)

		let credentials = try? await eventSender.config?.credentialsProvider.getCredentials()
		let token = credentials?.token ?? "MISSING TOKEN"
		
		XCTAssertEqual(token, "testAccessToken")
	}

	func testSendEventFailsWhenConfigurationNotCalled() async {
		let notConfiguredEventSender = TidalEventSender()
		var caughtError: Error?
		
		do {
			try await notConfiguredEventSender.sendEvent(
				name: "testEvent",
				consentCategory: .necessary,
				payload: "testPayload"
			)
		} catch {
			caughtError = error
		}
		
		switch caughtError as? EventProducerError {
			case .notConfigured:
				break
			default:
				XCTFail("Error is not thrown or has a wrong type")
		}
	}

	func testEventSenderConfig() async {
		let accessToken = "accessToken"
		let consumerUri = "consumerUri"
		let maxDiskUsageBytes = 1024
		
		let mockCredentialsProvider = mockCredentialsProvider(withToken: accessToken)
				
		eventSender.config(
			EventConfig(
				credentialsProvider: mockCredentialsProvider,
				maxDiskUsageBytes: maxDiskUsageBytes,
				consumerUri: consumerUri
			)
		)
		
		let credentials = try? await eventSender.config?.credentialsProvider.getCredentials()
		let token = credentials?.token
		
		XCTAssertEqual(token, accessToken)
		XCTAssertEqual(eventSender.config?.consumerUri, consumerUri)
		XCTAssertEqual(eventSender.config?.maxDiskUsageBytes, maxDiskUsageBytes)
	}

	func testEventsPersisted() async throws {
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
	
	func testEventsEncoded() async throws {
		guard let consumerUri = eventSender.config?.consumerUri else {
			XCTFail("Default consumerUri should be set")
			return
		}
		
		let eventScheduler = EventScheduler(consumerUri: consumerUri, eventQueue: queue, monitoring: monitoring)
		let event1 = Event(
			name: "testEvent#1",
			payload: "firstPayload"
		)
		
		let event2 = Event(
			name: "testEvent#2",
			payload: "https://api.tidal.com/v2/home/initiate?countryCode=NO"
		)
		
		
		let encodedEvents = eventScheduler.formatEvents([event1, event2])
		print("🔥\(encodedEvents)")
		XCTAssertTrue(encodedEvents.contains(where: { $0.value == "firstPayload" }))
		XCTAssertTrue(encodedEvents.contains(where: { $0.value == "https%3A//api.tidal.com/v2/home/initiate?countryCode%3DNO" }))
	}

	func testSendEventThroughScheduler() async throws {
		guard let consumerUri = eventSender.config?.consumerUri else {
			XCTFail("Default consumerUri should be set")
			return
		}
		let eventScheduler = EventScheduler(consumerUri: consumerUri, eventQueue: queue, monitoring: monitoring)
		let event = Event(
			name: "testEvent",
			payload: "payload"
		)

		try await queue.addEvent(event: event, consentCategory: .necessary)
		do {
			try await eventScheduler.sendAllEvents(headerHelper: headerHelper)
			XCTFail("Auth token is invalid - it *should* fail")
		} catch {
			let leftoverEvents = try await queue.getAllEvents().count
			XCTAssertEqual(leftoverEvents, 1)
		}

		let anonymousAuthProvider = MockCredentialsProvider(testToken: nil, isUserLoggedIn: false)
		headerHelper = HeaderHelper(credentialsProvider: anonymousAuthProvider)
		eventSender.config(
			.init(
				credentialsProvider: anonymousAuthProvider,
				maxDiskUsageBytes: maxDiskUsageBytes
			)
		)
		try await eventScheduler.sendAllEvents(headerHelper: headerHelper)
		let leftoverEvents = try await queue.getAllEvents().count
		XCTAssertEqual(leftoverEvents, 0)
	}

	func testSendEventTwoBatchesThroughScheduler() async throws {
		guard let consumerUri = eventSender.config?.consumerUri else {
			XCTFail("Default consumerUri should be set")
			return
		}
		let eventScheduler = EventScheduler(consumerUri: consumerUri, eventQueue: queue, monitoring: monitoring)
		let anonymousAuthProvider = MockCredentialsProvider(testToken: nil, isUserLoggedIn: false)
		headerHelper = HeaderHelper(credentialsProvider: anonymousAuthProvider)

		eventSender.config(
			.init(
				credentialsProvider: anonymousAuthProvider,
				maxDiskUsageBytes: maxDiskUsageBytes
			)
		)

		for index in 0 ... 15 {
			let event = Event(
				name: "testEvent#\(index)",
				payload: "payload#\(index)"
			)
			try await queue.addEvent(event: event, consentCategory: .necessary)
		}

		try await eventScheduler.sendAllEvents(headerHelper: headerHelper)
		let leftoverEvents = try await queue.getAllEvents().count

		XCTAssertEqual(leftoverEvents, 0)
	}

	func testBlockedConsentCategoriesEventsDropped() async throws {
		eventSender.setBlockedConsentCategories([ConsentCategory.targeting, ConsentCategory.performance])

		try await eventSender.sendEvent(
			name: "PerformanceEvent",
			consentCategory: ConsentCategory.performance,
			payload: "firstPayload"
		)

		try await eventSender.sendEvent(
			name: "NecessaryEvent",
			consentCategory: ConsentCategory.necessary,
			headers: ["test": "test"],
			payload: "secondPayload"
		)

		try await eventSender.sendEvent(
			name: "TargetingEvent",
			consentCategory: ConsentCategory.targeting,
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
		eventSender.setBlockedConsentCategories([])

		try await eventSender.sendEvent(
			name: "PerformanceEvent",
			consentCategory: .performance,
			headers: [HTTPHeaderKeys.consentCategory.rawValue: ConsentCategory.performance.rawValue],
			payload: "firstPayload"
		)

		try await eventSender.sendEvent(
			name: "NecessaryEvent",
			consentCategory: .necessary,
			headers: ["test": "test", HTTPHeaderKeys.consentCategory.rawValue: ConsentCategory.necessary.rawValue],
			payload: "secondPayload"
		)

		try await eventSender.sendEvent(
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
	
	func testSchedulerBatchExceedsSize() async throws {
		
		guard let consumerUri = eventSender.config?.consumerUri else {
			XCTFail("Default consumerUri should be set")
			return
		}
		
		let eventQueue = [
			Event(
				name: "testEvent#1",
				payload: "firstPayload"),
			Event(
				name: "testEvent#2",
				payload: "secondPayload"),
			Event(
				name: "testEvent#3",
				payload: "thirdPayload")
		]
		
		var eventScheduler = EventScheduler(consumerUri: consumerUri, maxDiskUsageBytes: 500, eventQueue: queue, monitoring: monitoring)
		
		/// Check that the events are allowed based on the scheduler's allowed queue size limit
		XCTAssertFalse(eventScheduler.getAllowedBatch(eventQueue).isEmpty)
		
		/// Reduce the maxDiskUsageBytes in order to drop the events
		eventScheduler = EventScheduler(consumerUri: consumerUri, maxDiskUsageBytes: 50, eventQueue: queue, monitoring: monitoring)
		
		/// Events that exceed the size will be dropped
		XCTAssertTrue(eventScheduler.getAllowedBatch(eventQueue).isEmpty)
		
	}
}
