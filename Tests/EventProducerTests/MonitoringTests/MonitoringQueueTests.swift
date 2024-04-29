@testable import EventProducer
import XCTest

final class MonitoringQueueTests: XCTestCase {
	private let sut: MonitoringQueue = .shared

	override func setUp() async throws {
		try await super.setUp()
		try await sut.deleteAllMonitoringInfo()
	}

	func testAddMonitoringEvent() async throws {
		let monitoringInfo = MonitoringInfo(
			id: "monitoringId123",
			consentFilteredEvents: ["necessary": 1],
			validationFailedEvents: [:],
			storingFailedEvents: [:]
		)

		try await sut.addNewMonitoringInfo(monitoringInfo)

		guard let monitoringInfo = try await sut.getMonitoringInfo() else {
			XCTFail("failed to getMonitoringInfo")
			return
		}

		XCTAssertEqual(monitoringInfo.id, "monitoringId123")
		XCTAssertEqual(monitoringInfo.consentFilteredEvents, ["necessary": 1])
		XCTAssertTrue(monitoringInfo.validationFailedEvents.isEmpty)
		XCTAssertTrue(monitoringInfo.storingFailedEvents.isEmpty)
	}

	func testDeleteMonitoringInfo() async throws {
		let monitoringInfo = try await sut.getMonitoringInfo()
		XCTAssertNil(monitoringInfo)

		try await sut.addNewMonitoringInfo(
			.init(
				consentFilteredEvents: [:],
				validationFailedEvents: [:],
				storingFailedEvents: ["storage-monitoring-fail": 3]
			)
		)

		let addedMonitoringInfo = try await sut.getMonitoringInfo()

		XCTAssertNotNil(addedMonitoringInfo)
		XCTAssertTrue(addedMonitoringInfo!.consentFilteredEvents.isEmpty)
		XCTAssertTrue(addedMonitoringInfo!.validationFailedEvents.isEmpty)
		XCTAssertEqual(addedMonitoringInfo!.storingFailedEvents, ["storage-monitoring-fail": 3])

		try await sut.deleteAllMonitoringInfo()
		let monitoringInfo2 = try await sut.getMonitoringInfo()

		XCTAssertNil(monitoringInfo2)
	}
}
