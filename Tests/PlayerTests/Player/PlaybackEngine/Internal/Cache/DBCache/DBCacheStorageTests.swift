import GRDB
@testable import Player
import XCTest

class DBCacheStorageTests: XCTestCase {
	var dbQueue: DatabaseQueue!
	var cacheStorage: DBCacheStorage!

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

	override func setUpWithError() throws {
		// Create an in-memory database for testing
		dbQueue = try DatabaseQueue()

		cacheStorage = DBCacheStorage(dbQueue: dbQueue)
	}

	override func tearDownWithError() throws {
		dbQueue = nil
		cacheStorage = nil
	}

	func testInsertCacheEntry() throws {
		try cacheStorage.save(DBCacheStorageTests.cacheEntry1)

		let fetchedEntry = try XCTUnwrap(cacheStorage.get(key: DBCacheStorageTests.cacheEntry1.key))
		XCTAssertEqual(fetchedEntry, DBCacheStorageTests.cacheEntry1)
	}

	func testUpdateCacheEntry() throws {
		try cacheStorage.save(DBCacheStorageTests.cacheEntry1)

		// Update the entry
		var updatedSize = 1000
		var updatedEntry = DBCacheStorageTests.cacheEntry1
		updatedEntry.size = updatedSize
		try cacheStorage.update(updatedEntry)

		let fetchedEntry = try XCTUnwrap(cacheStorage.get(key: DBCacheStorageTests.cacheEntry1.key))
		XCTAssertEqual(fetchedEntry.size, updatedSize)
	}

	func testDeleteCacheEntry() throws {
		try cacheStorage.save(DBCacheStorageTests.cacheEntry1)

		try cacheStorage.delete(key: DBCacheStorageTests.cacheEntry1.key)

		let fetchedEntry = try cacheStorage.get(key: DBCacheStorageTests.cacheEntry1.key)
		XCTAssertNil(fetchedEntry)
	}

	func testGetAllCacheEntries() throws {
		try cacheStorage.save(DBCacheStorageTests.cacheEntry1)
		try cacheStorage.save(DBCacheStorageTests.cacheEntry2)

		let allEntries = try cacheStorage.getAll()
		XCTAssertEqual(allEntries.count, 2)
		XCTAssertEqual(allEntries[0], DBCacheStorageTests.cacheEntry1)
		XCTAssertEqual(allEntries[1], DBCacheStorageTests.cacheEntry2)
	}

	func testCalculateTotalSize() throws {
		try cacheStorage.save(DBCacheStorageTests.cacheEntry1)
		try cacheStorage.save(DBCacheStorageTests.cacheEntry2)
		try cacheStorage.save(DBCacheStorageTests.cacheEntry3)

		let totalSize = try cacheStorage.totalSize()
		XCTAssertEqual(totalSize, 1600)
	}

	func testPruneToSize() throws {
		try cacheStorage.save(DBCacheStorageTests.cacheEntry1)
		try cacheStorage.save(DBCacheStorageTests.cacheEntry2)
		try cacheStorage.save(DBCacheStorageTests.cacheEntry3)

		// Prune to keep only 1000 bytes of data
		try cacheStorage.pruneToSize(1000)

		let allEntries = try cacheStorage.getAll()
		XCTAssertEqual(allEntries.count, 2)
		XCTAssertEqual(allEntries[0], DBCacheStorageTests.cacheEntry1)
		XCTAssertEqual(allEntries[1], DBCacheStorageTests.cacheEntry2)
	}
}
