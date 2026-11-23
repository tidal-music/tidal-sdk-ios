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
	private var consumer: FirstRequestHoldingConsumer!

	override func setUp() async throws {
		try await super.setUp()
		queue = EventQueue(databaseURL: databaseURL)
		consumer = FirstRequestHoldingConsumer()
	}

	override func tearDown() async throws {
		try? FileManager.default.removeItem(at: databaseURL)
		try await super.tearDown()
	}

	func testSchedulersSharingAQueueSendEachEventOnce() async throws {
		let events = try await enqueueEvents(count: 3)
		let firstScheduler = makeScheduler()
		let secondScheduler = makeScheduler()

		async let firstFlush: Void = firstScheduler.sendAllEvents(headerHelper: headerHelper)
		try await waitUntilReceived(events[0].id)
		try await secondScheduler.sendAllEvents(headerHelper: headerHelper)
		await consumer.releaseHeldRequest()
		try await firstFlush

		let receivedIDs = await consumer.receivedIDs
		XCTAssertEqual(receivedIDs.sorted(), events.map(\.id).sorted())
		let leftoverEvents = try await queue.getAllEvents()
		XCTAssertTrue(leftoverEvents.isEmpty)
	}

	func testAppFlushDuringSlowTimerFlushSendsNewEventsWithoutWaiting() async throws {
		let timerEvents = try await enqueueEvents(count: 2)
		let scheduler = makeScheduler()

		async let timerFlush: Void = scheduler.sendAllEvents(headerHelper: headerHelper)
		try await waitUntilReceived(timerEvents[0].id)
		let appEvents = try await enqueueEvents(count: 1)
		async let appFlush: Void = scheduler.sendAllEvents(headerHelper: headerHelper)
		try await waitUntilReceived(appEvents[0].id)
		await consumer.releaseHeldRequest()
		_ = try await (timerFlush, appFlush)

		let receivedIDs = await consumer.receivedIDs
		XCTAssertEqual(receivedIDs.sorted(), (timerEvents + appEvents).map(\.id).sorted())
		let leftoverEvents = try await queue.getAllEvents()
		XCTAssertTrue(leftoverEvents.isEmpty)
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

	private func waitUntilReceived(_ id: String) async throws {
		let deadline = Date().addingTimeInterval(2)
		while await !consumer.receivedIDs.contains(id) {
			guard Date() < deadline else {
				XCTFail("Event \(id) never reached the consumer")
				await consumer.releaseHeldRequest()
				return
			}
			try await Task.sleep(nanoseconds: 10_000_000)
		}
	}
}

// MARK: - FirstRequestHoldingConsumer

private actor FirstRequestHoldingConsumer: HTTPTransport {
	private(set) var receivedIDs: [String] = []
	private var hasHeldARequest = false
	private var isReleased = false
	private var heldRequest: CheckedContinuation<Void, Error>?

	func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
		let ids = Self.eventIDs(in: request)
		receivedIDs.append(contentsOf: ids)

		if !hasHeldARequest {
			hasHeldARequest = true
			try await withTaskCancellationHandler {
				try await holdUntilReleased()
			} onCancel: {
				Task { await self.cancelHeldRequest() }
			}
		}

		let entries = ids.map { "<SendMessageBatchResultEntry><Id>\($0)</Id></SendMessageBatchResultEntry>" }.joined()
		let xml = "<SendMessageBatchResponse><SendMessageBatchResult>\(entries)</SendMessageBatchResult></SendMessageBatchResponse>"
		let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
		return (Data(xml.utf8), response)
	}

	func releaseHeldRequest() {
		isReleased = true
		heldRequest?.resume()
		heldRequest = nil
	}

	private func holdUntilReleased() async throws {
		try Task.checkCancellation()
		guard !isReleased else {
			return
		}
		try await withCheckedThrowingContinuation { heldRequest = $0 }
	}

	private func cancelHeldRequest() {
		heldRequest?.resume(throwing: CancellationError())
		heldRequest = nil
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
