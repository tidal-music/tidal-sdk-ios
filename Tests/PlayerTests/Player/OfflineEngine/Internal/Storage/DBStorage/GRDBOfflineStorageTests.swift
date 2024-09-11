import Foundation
import GRDB
@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	static let offlineEntry1 = OfflineEntry.mock(
		productId: "1",
		size: 500,
		url: URL(
			string: "www.example.com/track1"
		)!
	)

	static let offlineEntry2 = OfflineEntry.mock(
		productId: "2",
		size: 300,
		url: URL(
			string: "www.example.com/track2"
		)!
	)
}

// MARK: - GRDBOfflineStorageTests

class GRDBOfflineStorageTests: XCTestCase {
	var dbQueue: DatabaseQueue!
	var offlineStorage: GRDBOfflineStorage!

	override func setUpWithError() throws {
		// Create an in-memory database for testing
		dbQueue = try DatabaseQueue()

		offlineStorage = GRDBOfflineStorage(dbQueue: dbQueue)
	}

	override func tearDownWithError() throws {
		dbQueue = nil
		offlineStorage = nil
	}

	func testInsertOfflineEntry() throws {
		try offlineStorage.save(Constants.offlineEntry1)

		let fetchedEntry = try XCTUnwrap(offlineStorage.get(mediaProduct: MediaProduct.mock(productId: "1")))
		XCTAssertEqual(fetchedEntry.productId, "1")
	}

	func testUpdateOfflineEntry() throws {
		try offlineStorage.save(Constants.offlineEntry1)

		// Update the entry
		let expectedLicenseUrl = URL(string: "www.example.com/license/track1")
		var updatedEntry = Constants.offlineEntry1
		updatedEntry.licenseUrl = expectedLicenseUrl
		try offlineStorage.update(updatedEntry)

		let fetchedEntry = try XCTUnwrap(offlineStorage.get(mediaProduct: MediaProduct.mock(productId: "1")))
		XCTAssertEqual(fetchedEntry.licenseUrl, expectedLicenseUrl)
	}

	func testDeleteOfflineEntry() throws {
		try offlineStorage.save(Constants.offlineEntry1)

		try offlineStorage.delete(mediaProduct: MediaProduct.mock(productId: "1"))

		let fetchedEntry = try offlineStorage.get(mediaProduct: MediaProduct.mock(productId: "1"))
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