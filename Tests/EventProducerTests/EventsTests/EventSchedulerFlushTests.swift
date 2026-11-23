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

	private let queue = EventQueue()
	private let headerHelper = HeaderHelper(credentialsProvider: AnonymousCredentialsProvider())
	private var scheduler: EventScheduler!

	override func setUp() async throws {
		try await super.setUp()
		try await queue.deleteAllEvents()
		EventBatchURLProtocol.reset()
		URLProtocol.registerClass(EventBatchURLProtocol.self)
		scheduler = EventScheduler(
			consumerUri: "https://\(EventBatchURLProtocol.host)",
			eventQueue: queue,
			monitoring: Monitoring(monitoringQueue: .init())
		)
	}

	override func tearDown() async throws {
		URLProtocol.unregisterClass(EventBatchURLProtocol.self)
		try await queue.deleteAllEvents()
		try await super.tearDown()
	}

	func testConcurrentFlushesSendEachEventOnce() async throws {
		let events = try await enqueueEvents(count: 3)

		async let timerFlush: Void = scheduler.sendAllEvents(headerHelper: headerHelper)
		async let appFlush: Void = scheduler.sendAllEvents(headerHelper: headerHelper)
		_ = try await (timerFlush, appFlush)

		XCTAssertEqual(EventBatchURLProtocol.sentIDs.sorted(), events.map(\.id).sorted())
		let leftoverEvents = try await queue.getAllEvents()
		XCTAssertTrue(leftoverEvents.isEmpty)
	}

	func testEventEnqueuedDuringFlushIsSentByNextFlush() async throws {
		let earlyEvents = try await enqueueEvents(count: 2)

		async let firstFlush: Void = scheduler.sendAllEvents(headerHelper: headerHelper)
		try await waitUntilFirstRequestArrives()
		let lateEvents = try await enqueueEvents(count: 1)
		try await scheduler.sendAllEvents(headerHelper: headerHelper)
		try await firstFlush

		XCTAssertEqual(EventBatchURLProtocol.sentIDs.sorted(), (earlyEvents + lateEvents).map(\.id).sorted())
		let leftoverEvents = try await queue.getAllEvents()
		XCTAssertTrue(leftoverEvents.isEmpty)
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

	private func waitUntilFirstRequestArrives() async throws {
		let deadline = Date().addingTimeInterval(5)
		while EventBatchURLProtocol.sentIDs.isEmpty {
			guard Date() < deadline else {
				XCTFail("The first flush never reached the network")
				return
			}
			try await Task.sleep(nanoseconds: 10_000_000)
		}
	}
}

// MARK: - EventBatchURLProtocol

private final class EventBatchURLProtocol: URLProtocol {
	static let host = "event-scheduler-flush-tests.invalid"
	private static let overlapWindow: TimeInterval = 0.3
	private static let lock = NSLock()
	private static var receivedIDs: [String] = []

	static var sentIDs: [String] {
		lock.lock()
		defer { lock.unlock() }
		return receivedIDs
	}

	static func reset() {
		lock.lock()
		receivedIDs = []
		lock.unlock()
	}

	override static func canInit(with request: URLRequest) -> Bool {
		request.url?.host == host
	}

	override static func canonicalRequest(for request: URLRequest) -> URLRequest {
		request
	}

	override func startLoading() {
		let ids = Self.eventIDs(in: Self.body(of: request))
		Self.lock.lock()
		Self.receivedIDs.append(contentsOf: ids)
		Self.lock.unlock()

		let entries = ids.map { "<SendMessageBatchResultEntry><Id>\($0)</Id></SendMessageBatchResultEntry>" }.joined()
		let xml = "<SendMessageBatchResponse><SendMessageBatchResult>\(entries)</SendMessageBatchResult></SendMessageBatchResponse>"
		let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!

		DispatchQueue.global().asyncAfter(deadline: .now() + Self.overlapWindow) { [self] in
			client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
			client?.urlProtocol(self, didLoad: Data(xml.utf8))
			client?.urlProtocolDidFinishLoading(self)
		}
	}

	override func stopLoading() {}

	private static func body(of request: URLRequest) -> String {
		guard let stream = request.httpBodyStream else {
			return ""
		}
		stream.open()
		defer { stream.close() }
		var data = Data()
		var buffer = [UInt8](repeating: 0, count: 4096)
		while stream.hasBytesAvailable {
			let read = stream.read(&buffer, maxLength: buffer.count)
			guard read > 0 else {
				break
			}
			data.append(buffer, count: read)
		}
		return String(data: data, encoding: .utf8) ?? ""
	}

	private static func eventIDs(in body: String) -> [String] {
		body.split(separator: "&").compactMap { pair in
			let parts = pair.split(separator: "=", maxSplits: 1)
			guard parts.count == 2, parts[0].hasPrefix("SendMessageBatchRequestEntry."), parts[0].hasSuffix(".Id") else {
				return nil
			}
			return String(parts[1])
		}
	}
}
