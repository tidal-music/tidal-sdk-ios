import Foundation
import GRDB
@testable import Player
import Testing

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

final class GRDBOfflineStorageTests {
	var dbQueue: DatabaseQueue!
	var offlineStorage: GRDBOfflineStorage!

	init() throws {
		// Create an in-memory database for testing
		dbQueue = try DatabaseQueue()
		try GRDBOfflineStorage.initializeDatabase(dbQueue: dbQueue)
		offlineStorage = GRDBOfflineStorage(dbQueue: dbQueue)
	}

	@Test
	func testInsertOfflineEntry() throws {
		do {
			let offlineEntry = Constants.offlineEntry1
			try offlineStorage.save(Constants.offlineEntry1)

			let fetchedEntry = try #require(try offlineStorage.get(key: offlineEntry.productId))
			#expect(fetchedEntry.productId == offlineEntry.productId)
		} catch {
			Issue.record("Test failed with error: \(error.localizedDescription)")
			throw error
		}
	}

	@Test
	func testUpdateOfflineEntry() throws {
		do {
			var offlineEntry = Constants.offlineEntry1
			try offlineStorage.save(offlineEntry)

			// Update the entry
			let expectedLicenseURL = URL(string: "www.example.com/license/track1")
			offlineEntry.licenseURL = expectedLicenseURL
			try offlineStorage.update(offlineEntry)

			let fetchedEntry = try #require(try offlineStorage.get(key: offlineEntry.productId))
			#expect(fetchedEntry.licenseURL == expectedLicenseURL)
		} catch {
			Issue.record("Test failed with error: \(error.localizedDescription)")
			throw error
		}
	}

	@Test
	func testDeleteOfflineEntry() throws {
		do {
			let offlineEntry = Constants.offlineEntry1
			try offlineStorage.save(offlineEntry)

			try offlineStorage.delete(key: offlineEntry.productId)

			let fetchedEntry = try offlineStorage.get(key: offlineEntry.productId)
			#expect(fetchedEntry == nil)
		} catch {
			Issue.record("Test failed with error: \(error.localizedDescription)")
			throw error
		}
	}

	@Test
	func testGetAllOfflineEntries() throws {
		do {
			try offlineStorage.save(Constants.offlineEntry1)
			try offlineStorage.save(Constants.offlineEntry2)

			let allEntries = try offlineStorage.getAll()
			#expect(allEntries.count == 2)
			#expect(allEntries[0].productId == Constants.offlineEntry1.productId)
			#expect(allEntries[1].productId == Constants.offlineEntry2.productId)
		} catch {
			Issue.record("Test failed with error: \(error.localizedDescription)")
			throw error
		}
	}

	@Test
	func testCalculateTotalSize() throws {
		do {
			let expectedTotalSize = Constants.offlineEntry1.size + Constants.offlineEntry2.size

			try offlineStorage.save(Constants.offlineEntry1)
			try offlineStorage.save(Constants.offlineEntry2)

			let totalSize = try offlineStorage.totalSize()
			#expect(totalSize == expectedTotalSize)
		} catch {
			Issue.record("Test failed with error: \(error.localizedDescription)")
			throw error
		}
	}
}
