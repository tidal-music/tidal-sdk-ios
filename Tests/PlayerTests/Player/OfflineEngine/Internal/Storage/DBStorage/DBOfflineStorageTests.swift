import Foundation
import GRDB
@testable import Player
import XCTest

class DBOfflineStorageTests: XCTestCase {
	var dbQueue: DatabaseQueue!
	var offlineStorage: DBOfflineStorage!

	static let offlineEntry1 = OfflineEntry.mock(
		productId: "1",
		url: URL(
			string: "www.example.com/track1"
		)!
	)

	static let offlineEntry2 = OfflineEntry.mock(
		productId: "2",
		url: URL(
			string: "www.example.com/track2"
		)!
	)

	override func setUpWithError() throws {
		// Create an in-memory database for testing
		dbQueue = try DatabaseQueue()

		offlineStorage = DBOfflineStorage(dbQueue: dbQueue)
	}

	override func tearDownWithError() throws {
		dbQueue = nil
		offlineStorage = nil
	}

	func testInsertOfflineEntry() throws {
		try offlineStorage.save(DBOfflineStorageTests.offlineEntry1)

		let fetchedEntry = try XCTUnwrap(offlineStorage.get(mediaProduct: MediaProduct.mock(productId: "1")))
		XCTAssertEqual(fetchedEntry.productId, "1")
	}

	func testUpdateOfflineEntry() throws {
		try offlineStorage.save(DBOfflineStorageTests.offlineEntry1)

		// Update the entry
		let expectedLicenseUrl = URL(string: "www.example.com/license/track1")
		var updatedEntry = DBOfflineStorageTests.offlineEntry1
		updatedEntry.licenseUrl = expectedLicenseUrl
		try offlineStorage.update(updatedEntry)

		let fetchedEntry = try XCTUnwrap(offlineStorage.get(mediaProduct: MediaProduct.mock(productId: "1")))
		XCTAssertEqual(fetchedEntry.licenseUrl, expectedLicenseUrl)
	}

	func testDeleteOfflineEntry() throws {
		try offlineStorage.save(DBOfflineStorageTests.offlineEntry1)

		try offlineStorage.delete(mediaProduct: MediaProduct.mock(productId: "1"))

		let fetchedEntry = try offlineStorage.get(mediaProduct: MediaProduct.mock(productId: "1"))
		XCTAssertNil(fetchedEntry)
	}

	func testGetAllOfflineEntries() throws {
		try offlineStorage.save(DBOfflineStorageTests.offlineEntry1)
		try offlineStorage.save(DBOfflineStorageTests.offlineEntry2)

		let allEntries = try offlineStorage.getAll()
		XCTAssertEqual(allEntries.count, 2)
		XCTAssertEqual(allEntries[0].productId, DBOfflineStorageTests.offlineEntry1.productId)
		XCTAssertEqual(allEntries[1].productId, DBOfflineStorageTests.offlineEntry2.productId)
	}
}
