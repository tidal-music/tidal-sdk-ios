import Foundation
import GRDB
@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	static let offlineEntry1 = OfflineEntry.mock(
		productId: "1",
		size: 500,
		URL: URL(
			string: "www.example.com/track1"
		)!
	)

	static let offlineEntry2 = OfflineEntry.mock(
		productId: "2",
		size: 300,
		URL: URL(
			string: "www.example.com/track2"
		)!
	)
}

// MARK: - GRDBOfflineStorageTests

final class GRDBOfflineStorageTests: XCTestCase {
	var dbQueue: DatabaseQueue!
	var offlineStorage: GRDBOfflineStorage!

	override func setUpWithError() throws {
		// Create an in-memory database for testing
		dbQueue = try DatabaseQueue()
		try GRDBOfflineStorage.initializeDatabase(dbQueue: dbQueue)
		offlineStorage = GRDBOfflineStorage(dbQueue: dbQueue)
	}

	override func tearDownWithError() throws {
		dbQueue = nil
		offlineStorage = nil
	}

	func testInsertOfflineEntry() throws {
		let offlineEntry = Constants.offlineEntry1
		try offlineStorage.save(Constants.offlineEntry1)

		let fetchedEntry = try XCTUnwrap(offlineStorage.get(key: offlineEntry.productId))
		XCTAssertEqual(fetchedEntry.productId, offlineEntry.productId)
	}

	func testUpdateOfflineEntry() throws {
		var offlineEntry = Constants.offlineEntry1
		try offlineStorage.save(offlineEntry)

		// Update the entry
		let expectedLicenseURL = URL(string: "www.example.com/license/track1")
		offlineEntry.licenseURL = expectedLicenseURL
		try offlineStorage.update(offlineEntry)

		let fetchedEntry = try XCTUnwrap(offlineStorage.get(key: offlineEntry.productId))
		XCTAssertEqual(fetchedEntry.licenseURL, expectedLicenseURL)
	}

	func testDeleteOfflineEntry() throws {
		let offlineEntry = Constants.offlineEntry1
		try offlineStorage.save(offlineEntry)

		try offlineStorage.delete(key: offlineEntry.productId)

		let fetchedEntry = try offlineStorage.get(key: offlineEntry.productId)
		XCTAssertNil(fetchedEntry)
	}

	func testGetAllOfflineEntries() throws {
		try offlineStorage.save(Constants.offlineEntry1)
		try offlineStorage.save(Constants.offlineEntry2)

		let allEntries = try offlineStorage.getAll()
		XCTAssertEqual(allEntries.count, 2)
		XCTAssertEqual(allEntries[0].productId, Constants.offlineEntry1.productId)
		XCTAssertEqual(allEntries[1].productId, Constants.offlineEntry2.productId)
	}

	func testCalculateTotalSize() throws {
		let expectedTotalSize = Constants.offlineEntry1.size + Constants.offlineEntry2.size

		try offlineStorage.save(Constants.offlineEntry1)
		try offlineStorage.save(Constants.offlineEntry2)

		let totalSize = try offlineStorage.totalSize()
		XCTAssertEqual(totalSize, expectedTotalSize)
	}
}
