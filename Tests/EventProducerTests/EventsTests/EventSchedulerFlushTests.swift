@testable import Auth
@testable import EventProducer
import XCTest

// MARK: - EventSchedulerFlushTests

final class EventSchedulerFlushTests: XCTestCase {
	private struct AnonymousCredentialsProvider: CredentialsProvider {
		var isUserLoggedIn: Bool { false }

		func getCredentials(apiErrorSubStatus: String?) async throws -> Credentials {
			Credentials(
				clientId: "",
				requestedScopes: .init(),
				clientUniqueKey: "",
				grantedScopes: .init(),
				userId: nil,
				expires: nil,
				token: nil
			)
		}
	}

	private let headerHelper = HeaderHelper(credentialsProvider: AnonymousCredentialsProvider())
	private let databaseURL = FileManager.default.temporaryDirectory
		.appendingPathComponent("EventSchedulerFlushTests-\(UUID().uuidString).sqlite")
	private var queue: EventQueue!
	private var consumer: HoldingConsumer!

	override func setUp() async throws {
		try await super.setUp()
		queue = EventQueue(databaseURL: databaseURL)
		consumer = HoldingConsumer(heldRequestCount: 1)
	}

	override func tearDown() async throws {
		try? FileManager.default.removeItem(at: databaseURL)
		try await super.tearDown()
	}

	func testSchedulersSharingAQueueSendEachEventOnce() async throws {
		let events = try await enqueueEvents(count: 3)
		let firstScheduler = makeScheduler()
		let secondScheduler = makeScheduler()

		async let firstFlush: Void = firstScheduler.timerTriggered(headerHelper: headerHelper)
		try await waitUntilReceived(events[0].id)
		try await secondScheduler.timerTriggered(headerHelper: headerHelper)
		await consumer.releaseRequest(0)
		try await firstFlush

		let receivedIDs = await consumer.receivedIDs
		XCTAssertEqual(receivedIDs.sorted(), events.map(\.id).sorted())
		let leftoverEvents = try await queue.getAllEvents()
		XCTAssertTrue(leftoverEvents.isEmpty)
	}

	func testAppFlushDuringHeldTimerFlushSendsNewEventsAndReturnsOnceTimerEventsAreDelivered() async throws {
		let timerEvents = try await enqueueEvents(count: 2)
		let scheduler = makeScheduler()

		async let timerFlush: Void = scheduler.timerTriggered(headerHelper: headerHelper)
		try await waitUntilReceived(timerEvents[0].id)
		let appEvents = try await enqueueEvents(count: 1)
		let appFlushReturned = Flag()
		let appFlush = Task {
			try await scheduler.sendAllEvents(headerHelper: headerHelper)
			await appFlushReturned.set()
		}
		try await waitUntilReceived(appEvents[0].id)
		try await Task.sleep(nanoseconds: 200_000_000)
		let returnedWhileTimerFlushWasHeld = await appFlushReturned.isSet
		XCTAssertFalse(returnedWhileTimerFlushWasHeld)

		await consumer.releaseRequest(0)
		try await timerFlush
		try await appFlush.value

		let receivedIDs = await consumer.receivedIDs
		XCTAssertEqual(receivedIDs.sorted(), (timerEvents + appEvents).map(\.id).sorted())
		let leftoverEvents = try await queue.getAllEvents()
		XCTAssertTrue(leftoverEvents.isEmpty)
	}

	func testAppFlushDuringFailedTimerFlushResendsTheTimerEvents() async throws {
		let timerEvents = try await enqueueEvents(count: 2)
		let scheduler = makeScheduler()

		async let timerFlush: Void = scheduler.timerTriggered(headerHelper: headerHelper)
		try await waitUntilReceived(timerEvents[0].id)
		let appEvents = try await enqueueEvents(count: 1)
		let appFlush = Task { try await scheduler.sendAllEvents(headerHelper: headerHelper) }
		try await waitUntilReceived(appEvents[0].id)
		await consumer.failRequest(0)
		do {
			try await timerFlush
			XCTFail("The timer flush should fail")
		} catch {}
		try await appFlush.value

		let receivedIDs = await consumer.receivedIDs
		XCTAssertEqual(receivedIDs.sorted(), (timerEvents + timerEvents + appEvents).map(\.id).sorted())
		let leftoverEvents = try await queue.getAllEvents()
		XCTAssertTrue(leftoverEvents.isEmpty)
	}

	func testAppFlushWaitsForATimerFlushThatClaimsNewEventsWhileItWaits() async throws {
		consumer = HoldingConsumer(heldRequestCount: 3)
		let (firstTimerRequest, appRequest, secondTimerRequest) = (0, 1, 2)
		let firstTimerEvents = try await enqueueEvents(count: 2)
		let scheduler = makeScheduler()

		async let firstTimerFlush: Void = scheduler.timerTriggered(headerHelper: headerHelper)
		try await waitUntilReceived(firstTimerEvents[0].id)
		let appEvents = try await enqueueEvents(count: 1)
		let appFlush = Task { try await scheduler.sendAllEvents(headerHelper: headerHelper) }
		try await waitUntilReceived(appEvents[0].id)
		let secondTimerEvents = try await enqueueEvents(count: 1)
		async let secondTimerFlush: Void = scheduler.timerTriggered(headerHelper: headerHelper)
		try await waitUntilReceived(secondTimerEvents[0].id)

		await consumer.releaseRequest(appRequest)
		await consumer.failRequest(firstTimerRequest)
		do {
			try await firstTimerFlush
			XCTFail("The first timer flush should fail")
		} catch {}
		try await waitUntilReceived(firstTimerEvents[0].id, times: 2)
		await consumer.failRequest(secondTimerRequest)
		do {
			try await secondTimerFlush
			XCTFail("The second timer flush should fail")
		} catch {}
		try await appFlush.value

		let leftoverEvents = try await queue.getAllEvents()
		XCTAssertEqual(leftoverEvents.map(\.id), [])
		let receivedIDs = await consumer.receivedIDs
		let expectedIDs = firstTimerEvents + appEvents + secondTimerEvents + firstTimerEvents + secondTimerEvents
		XCTAssertEqual(receivedIDs.sorted(), expectedIDs.map(\.id).sorted())
	}

	func testCancelledFlushLeavesItsEventsForTheNextFlush() async throws {
		let events = try await enqueueEvents(count: 2)
		let scheduler = makeScheduler()

		let cancelledFlush = Task { try await scheduler.sendAllEvents(headerHelper: headerHelper) }
		try await waitUntilReceived(events[0].id)
		cancelledFlush.cancel()
		_ = await cancelledFlush.result
		try await scheduler.sendAllEvents(headerHelper: headerHelper)

		let receivedIDs = await consumer.receivedIDs
		XCTAssertEqual(receivedIDs.sorted(), (events + events).map(\.id).sorted())
		let leftoverEvents = try await queue.getAllEvents()
		XCTAssertTrue(leftoverEvents.isEmpty)
	}

	private func makeScheduler() -> EventScheduler {
		EventScheduler(
			consumerUri: "https://consumer.invalid",
			eventQueue: queue,
			monitoring: Monitoring(monitoringQueue: .init()),
			transport: consumer
		)
	}

	private func enqueueEvents(count: Int) async throws -> [Event] {
		var events: [Event] = []
		for index in 0 ..< count {
			let event = Event(name: "flushTestEvent", payload: "payload#\(index)")
			try await queue.addEvent(event: event, consentCategory: .necessary)
			events.append(event)
		}
		return events
	}

	private func waitUntilReceived(_ id: String, times: Int = 1) async throws {
		let deadline = Date().addingTimeInterval(2)
		while await consumer.receivedIDs.filter({ $0 == id }).count < times {
			guard Date() < deadline else {
				XCTFail("Event \(id) never reached the consumer")
				await consumer.stopHolding()
				return
			}
			try await Task.sleep(nanoseconds: 10_000_000)
		}
	}
}

// MARK: - Flag

private actor Flag {
	private(set) var isSet = false

	func set() {
		isSet = true
	}
}

// MARK: - HoldingConsumer

private actor HoldingConsumer: HTTPTransport {
	private(set) var receivedIDs: [String] = []
	private var heldRequestCount: Int
	private var requestCount = 0
	private var heldRequests: [Int: CheckedContinuation<Void, Error>] = [:]
	private var outcomesBeforeArrival: [Int: Result<Void, Error>] = [:]

	init(heldRequestCount: Int) {
		self.heldRequestCount = heldRequestCount
	}

	func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
		let ids = Self.eventIDs(in: request)
		receivedIDs.append(contentsOf: ids)
		let index = requestCount
		requestCount += 1

		if index < heldRequestCount {
			try await withTaskCancellationHandler {
				try await hold(index)
			} onCancel: {
				Task { await self.resolve(index, with: .failure(CancellationError())) }
			}
		}

		let entries = ids.map { "<SendMessageBatchResultEntry><Id>\($0)</Id></SendMessageBatchResultEntry>" }.joined()
		let xml = "<SendMessageBatchResponse><SendMessageBatchResult>\(entries)</SendMessageBatchResult></SendMessageBatchResponse>"
		let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
		return (Data(xml.utf8), response)
	}

	func releaseRequest(_ index: Int) {
		resolve(index, with: .success(()))
	}

	func failRequest(_ index: Int) {
		resolve(index, with: .failure(URLError(.networkConnectionLost)))
	}

	func stopHolding() {
		heldRequestCount = 0
		heldRequests.values.forEach { $0.resume() }
		heldRequests = [:]
	}

	private func hold(_ index: Int) async throws {
		try Task.checkCancellation()
		if let outcome = outcomesBeforeArrival.removeValue(forKey: index) {
			return try outcome.get()
		}
		try await withCheckedThrowingContinuation { heldRequests[index] = $0 }
	}

	private func resolve(_ index: Int, with outcome: Result<Void, Error>) {
		if let heldRequest = heldRequests.removeValue(forKey: index) {
			heldRequest.resume(with: outcome)
		} else {
			outcomesBeforeArrival[index] = outcome
		}
	}

	private static func eventIDs(in request: URLRequest) -> [String] {
		let body = request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? ""
		return body.split(separator: "&").compactMap { pair in
			let parts = pair.split(separator: "=", maxSplits: 1)
			guard parts.count == 2, parts[0].hasPrefix("SendMessageBatchRequestEntry."), parts[0].hasSuffix(".Id") else {
				return nil
			}
			return String(parts[1])
		}
	}
}
