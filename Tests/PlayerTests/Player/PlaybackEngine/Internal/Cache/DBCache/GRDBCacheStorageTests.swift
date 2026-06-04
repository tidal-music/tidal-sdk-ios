import Foundation
import GRDB
@testable import Player
import Testing

// MARK: - Constants

private enum Constants {
	static let updatedSize = 1234

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

final class GRDBCacheStorageTests {
	var dbQueue: DatabaseQueue!
	var cacheStorage: GRDBCacheStorage!

	init() throws {
		// Create an in-memory database for testing
		dbQueue = try DatabaseQueue()

		cacheStorage = GRDBCacheStorage(dbQueue: dbQueue)
	}

	@Test
	func testInsertCacheEntry() throws {
		do {
			try cacheStorage.save(Constants.cacheEntry1)

			let fetchedEntry = try #require(try cacheStorage.get(key: Constants.cacheEntry1.key))
			#expect(fetchedEntry == Constants.cacheEntry1)
		} catch {
			Issue.record("Test failed with error: \(error.localizedDescription)")
			throw error
		}
	}

	@Test
	func testUpdateCacheEntry() throws {
		do {
			try cacheStorage.save(Constants.cacheEntry1)

			// Update the entry
			var updatedEntry = Constants.cacheEntry1
			updatedEntry.size = Constants.updatedSize
			try cacheStorage.update(updatedEntry)

			let fetchedEntry = try #require(try cacheStorage.get(key: Constants.cacheEntry1.key))
			#expect(fetchedEntry.size == updatedEntry.size)
		} catch {
			Issue.record("Test failed with error: \(error.localizedDescription)")
			throw error
		}
	}

	@Test
	func testDeleteCacheEntry() throws {
		do {
			try cacheStorage.save(Constants.cacheEntry1)

			try cacheStorage.delete(key: Constants.cacheEntry1.key)

			let fetchedEntry = try cacheStorage.get(key: Constants.cacheEntry1.key)
			#expect(fetchedEntry == nil)
		} catch {
			Issue.record("Test failed with error: \(error.localizedDescription)")
			throw error
		}
	}

	@Test
	func testGetAllCacheEntries() throws {
		do {
			try cacheStorage.save(Constants.cacheEntry1)
			try cacheStorage.save(Constants.cacheEntry2)

			let allEntries = try cacheStorage.getAll()
			#expect(allEntries.count == 2)
			#expect(allEntries[0] == Constants.cacheEntry1)
			#expect(allEntries[1] == Constants.cacheEntry2)
		} catch {
			Issue.record("Test failed with error: \(error.localizedDescription)")
			throw error
		}
	}

	@Test
	func testCalculateTotalSize() throws {
		do {
			try cacheStorage.save(Constants.cacheEntry1)
			try cacheStorage.save(Constants.cacheEntry2)
			try cacheStorage.save(Constants.cacheEntry3)

			let totalSize = try cacheStorage.totalSize()
			#expect(totalSize == 1600)
		} catch {
			Issue.record("Test failed with error: \(error.localizedDescription)")
			throw error
		}
	}

	@Test
	func testPruneToSize() throws {
		do {
			try cacheStorage.save(Constants.cacheEntry1)
			try cacheStorage.save(Constants.cacheEntry2)
			try cacheStorage.save(Constants.cacheEntry3)

			// Prune to keep only 1000 bytes of data
			try cacheStorage.pruneToSize(1000)

			let allEntries = try cacheStorage.getAll()
			#expect(allEntries.count == 2)
			#expect(allEntries[0] == Constants.cacheEntry1)
			#expect(allEntries[1] == Constants.cacheEntry2)
		} catch {
			Issue.record("Test failed with error: \(error.localizedDescription)")
			throw error
		}
	}
}
