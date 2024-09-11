import GRDB
@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	static let cacheEntry1 = CacheEntry.mock(
		key: "key1",
		type: CacheEntryType.hls,
		url: URL(string: "https://example.com/key1")!,
		lastAccessedAt: Date(timeIntervalSinceReferenceDate: 1000),
		size: 500
	)
	static let cacheEntry2 = CacheEntry.mock(
		key: "key2",
		type: CacheEntryType.progressive,
		url: URL(string: "https://example.com/key2")!,
		lastAccessedAt: Date(timeIntervalSinceReferenceDate: 1000).addingTimeInterval(-180),
		size: 300
	)
	static let cacheEntry3 = CacheEntry.mock(
		key: "key3",
		type: CacheEntryType.hls,
		url: URL(string: "https://example.com/key3")!,
		lastAccessedAt: Date(timeIntervalSinceReferenceDate: 1000).addingTimeInterval(-360),
		size: 800
	)
}

// MARK: - GRDBCacheStorageTests

final class GRDBCacheStorageTests: XCTestCase {
	var dbQueue: DatabaseQueue!
	var cacheStorage: GRDBCacheStorage!

	override func setUpWithError() throws {
		// Create an in-memory database for testing
		dbQueue = try DatabaseQueue()

		cacheStorage = GRDBCacheStorage(dbQueue: dbQueue)
	}

	override func tearDownWithError() throws {
		dbQueue = nil
		cacheStorage = nil
	}

	func testInsertCacheEntry() throws {
		try cacheStorage.save(Constants.cacheEntry1)

		let fetchedEntry = try XCTUnwrap(cacheStorage.get(key: Constants.cacheEntry1.key))
		XCTAssertEqual(fetchedEntry, Constants.cacheEntry1)
	}

	func testUpdateCacheEntry() throws {
		try cacheStorage.save(Constants.cacheEntry1)

		// Update the entry
		var updatedSize = 1000
		var updatedEntry = Constants.cacheEntry1
		updatedEntry.size = updatedSize
		try cacheStorage.update(updatedEntry)

		let fetchedEntry = try XCTUnwrap(cacheStorage.get(key: Constants.cacheEntry1.key))
		XCTAssertEqual(fetchedEntry.size, updatedSize)
	}

	func testDeleteCacheEntry() throws {
		try cacheStorage.save(Constants.cacheEntry1)

		try cacheStorage.delete(key: Constants.cacheEntry1.key)

		let fetchedEntry = try cacheStorage.get(key: Constants.cacheEntry1.key)
		XCTAssertNil(fetchedEntry)
	}

	func testGetAllCacheEntries() throws {
		try cacheStorage.save(Constants.cacheEntry1)
		try cacheStorage.save(Constants.cacheEntry2)

		let allEntries = try cacheStorage.getAll()
		XCTAssertEqual(allEntries.count, 2)
		XCTAssertEqual(allEntries[0], Constants.cacheEntry1)
		XCTAssertEqual(allEntries[1], Constants.cacheEntry2)
	}

	func testCalculateTotalSize() throws {
		try cacheStorage.save(Constants.cacheEntry1)
		try cacheStorage.save(Constants.cacheEntry2)
		try cacheStorage.save(Constants.cacheEntry3)

		let totalSize = try cacheStorage.totalSize()
		XCTAssertEqual(totalSize, 1600)
	}

	func testPruneToSize() throws {
		try cacheStorage.save(Constants.cacheEntry1)
		try cacheStorage.save(Constants.cacheEntry2)
		try cacheStorage.save(Constants.cacheEntry3)

		// Prune to keep only 1000 bytes of data
		try cacheStorage.pruneToSize(1000)

		let allEntries = try cacheStorage.getAll()
		XCTAssertEqual(allEntries.count, 2)
		XCTAssertEqual(allEntries[0], Constants.cacheEntry1)
		XCTAssertEqual(allEntries[1], Constants.cacheEntry2)
	}
}
