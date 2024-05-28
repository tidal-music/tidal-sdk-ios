@testable import EventProducer
@testable import Auth
import XCTest

final class MonitoringTests: XCTestCase {
	private struct MockCredentialsProvider: CredentialsProvider {
		func getCredentials(apiErrorSubStatus: String?) async throws -> Credentials {
			return Credentials(
				clientId: "",
				requestedScopes: .init(),
				clientUniqueKey: "",
				grantedScopes: .init(),
				userId: "testUserId",
				expires: nil,
				token: "testAccessToken"
			)
		}
		
		var isUserLoggedIn: Bool
	}

	private let sut: Monitoring = .shared
	private let monitoringQueue: MonitoringQueue = .shared
	private var headerHelper: HeaderHelper!
	private let maxDiskUsageBytes = 20480
	
	private var mockCredentialsProvider: CredentialsProvider {
		MockCredentialsProvider(isUserLoggedIn: true)
	}
	
	private var mockMonitoringScheduler: MonitoringScheduler {
		MonitoringScheduler(consumerUri: "https://consumer.uri")
	}

	override func setUp() {
		super.setUp()
		headerHelper = .init(credentialsProvider: MockCredentialsProvider(isUserLoggedIn: true))
	}

	override func tearDown() async throws {
		try await super.tearDown()
		try await monitoringQueue.deleteAllMonitoringInfo()
		let monitoringInfoAfterDeletion = try await monitoringQueue.getMonitoringInfo()
		XCTAssertNil(monitoringInfoAfterDeletion)
	}

	func testGetMonitoringEvent() async throws {
		let monitoringInfo = MonitoringInfo(
			id: "monitoringId123",
			consentFilteredEvents: ["necessary": 1],
			validationFailedEvents: [:],
			storingFailedEvents: [:]
		)

		guard let event = await sut.getMonitoringEvent(from: monitoringInfo, headerHelper: headerHelper) else {
			XCTFail("Failed to get getMonitoringEvent")
			return
		}

		XCTAssertEqual(event.name, Monitoring.eventName)
	}

	func testUpdateMonitoringEvent() async throws {
		let monitoringInfo = MonitoringInfo(
			id: "monitoringId123",
			consentFilteredEvents: [:],
			validationFailedEvents: [:],
			storingFailedEvents: [:]
		)

		let eventName = "tepl-monitoring-event"
		try await monitoringQueue.addNewMonitoringInfo(monitoringInfo)

		try await sut.updateMonitoringEvent(
			monitoringEventType: .failedStorage,
			eventName: eventName
		)

		try await sut.updateMonitoringEvent(
			monitoringEventType: .failedStorage,
			eventName: eventName
		)

		try await sut.updateMonitoringEvent(
			monitoringEventType: .failedValidation,
			eventName: eventName
		)

		guard let monitoringInfo = await sut.getMonitoringInfo() else {
			XCTFail("Failed to get getMonitoringEvent")
			return
		}

		XCTAssertNil(monitoringInfo.consentFilteredEvents[eventName])
		XCTAssertEqual(monitoringInfo.validationFailedEvents[eventName], 1)
		XCTAssertEqual(monitoringInfo.storingFailedEvents[eventName], 2)
	}

	func testMonitoringInfoAlwaysHasSingleObject() async throws {
		let monitoringInfo = MonitoringInfo(
			id: "monitoringId123",
			consentFilteredEvents: ["necessary": 1],
			validationFailedEvents: [:],
			storingFailedEvents: [:]
		)

		let eventName = "tepl-monitoring-event"
		let initialFetchedMonitoringInfo = await sut.getMonitoringInfo()
		XCTAssertNil(initialFetchedMonitoringInfo)

		try await monitoringQueue.addNewMonitoringInfo(monitoringInfo)

		try await sut.updateMonitoringEvent(
			monitoringEventType: .filteredConsent,
			eventName: eventName
		)

		try await sut.updateMonitoringEvent(
			monitoringEventType: .filteredConsent,
			eventName: eventName
		)

		try await sut.updateMonitoringEvent(
			monitoringEventType: .failedValidation,
			eventName: eventName
		)

		try await sut.updateMonitoringEvent(
			monitoringEventType: .failedStorage,
			eventName: eventName
		)

		guard let monitoringInfo = await sut.getMonitoringInfo() else {
			XCTFail("failed to getMonitoringInfo")
			return
		}

		let allMonitoringInfo = try await monitoringQueue.getAllMonitoringInfo()

		XCTAssertEqual(allMonitoringInfo.first, monitoringInfo)
		XCTAssertEqual(allMonitoringInfo.count, 1)
		XCTAssertEqual(monitoringInfo.validationFailedEvents[eventName], 1)
		XCTAssertEqual(monitoringInfo.consentFilteredEvents[eventName], 2)
		XCTAssertEqual(monitoringInfo.storingFailedEvents[eventName], 1)
	}

	func testClearMonitoringInfoAddsMonitoringInfo() async throws {
		let monitoringInfo = MonitoringInfo(
			id: "monitoringId123",
			consentFilteredEvents: ["necessary": 1],
			validationFailedEvents: [:],
			storingFailedEvents: [:]
		)

		let initialFetchedMonitoringInfo = await sut.getMonitoringInfo()
		XCTAssertNil(initialFetchedMonitoringInfo)

		try await monitoringQueue.addNewMonitoringInfo(monitoringInfo)

		var allMonitoringInfo = try await monitoringQueue.getAllMonitoringInfo()
		XCTAssertEqual(allMonitoringInfo.first, monitoringInfo)
		XCTAssertEqual(allMonitoringInfo.count, 1)
		let monitoringInfo1 = try await monitoringQueue.getMonitoringInfo()
		XCTAssertEqual(monitoringInfo, monitoringInfo1)

		await sut.clearMonitoringInfo()

		allMonitoringInfo = try await monitoringQueue.getAllMonitoringInfo()
		XCTAssertEqual(allMonitoringInfo.last, sut.emptyMonitoringInfo)
		XCTAssertEqual(allMonitoringInfo.count, 2)
		let monitoringInfo2 = try await monitoringQueue.getMonitoringInfo()
		XCTAssertEqual(sut.emptyMonitoringInfo, monitoringInfo2)
	}

	func testMonitoringSchedulerSendMonitoringEventDeletesMonitoringInfo() async throws {
		let monitoringInfo = MonitoringInfo(
			consentFilteredEvents: ["necessary": 1],
			validationFailedEvents: [:],
			storingFailedEvents: [:]
		)

		let initialMonitoringInfo = await sut.getMonitoringInfo()
		XCTAssertNil(initialMonitoringInfo)

		try await monitoringQueue.addNewMonitoringInfo(monitoringInfo)
		let addedMonitoring = await sut.getMonitoringInfo()
		XCTAssertEqual(monitoringInfo, addedMonitoring)

		await mockMonitoringScheduler.sendMonitoringEvent(headerHelper: headerHelper)

		let monitoringInfoAfterDeletion = await sut.getMonitoringInfo()
		XCTAssertEqual(sut.emptyMonitoringInfo, monitoringInfoAfterDeletion)
	}
}
