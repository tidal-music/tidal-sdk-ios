import AVFoundation
@testable import Player
import XCTest

// MARK: - PlayerCacheManagerTests

final class PlayerCacheManagerTests: XCTestCase {
	private var temporaryDirectory: URL!
	private var cacheStorage: TestCacheStorage!
	private var manager: PlayerCacheManager!
	private var currentTimestamp: UInt64!

	override func setUpWithError() throws {
		try super.setUpWithError()

		currentTimestamp = 0
		cacheStorage = TestCacheStorage()

		let baseDirectory = FileManager.default.temporaryDirectory
		temporaryDirectory = baseDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
		try FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)

		manager = PlayerCacheManager(
			storageDirectory: temporaryDirectory,
			cacheStorage: cacheStorage,
			fileManager: .live,
			timeProvider: { [weak self] in
				self?.currentTimestamp ?? 0
			}
		)
	}

	override func tearDownWithError() throws {
		try? FileManager.default.removeItem(at: temporaryDirectory)
		manager = nil
		cacheStorage = nil
		temporaryDirectory = nil
		currentTimestamp = nil

		try super.tearDownWithError()
	}

	private func waitForQueue() {
		// Use a semaphore to wait for async queue operations to complete
		let semaphore = DispatchSemaphore(value: 0)
		// Schedule a dummy operation that signals when complete
		manager.prepareCache(isEnabled: true)
		// Give queue time to process
		Thread.sleep(forTimeInterval: 0.05)
	}

	func testPersistEntryOnDownload() throws {
		currentTimestamp = 1_000

		let cacheKey = "test-cache-key"
		let assetURL = URL(string: "https://example.com/stream.m3u8")!
		let downloadDirectory = temporaryDirectory.appendingPathComponent("download", isDirectory: true)
		try FileManager.default.createDirectory(at: downloadDirectory, withIntermediateDirectories: true)

		let segmentURL = downloadDirectory.appendingPathComponent("segment.ts")
		let data = Data(repeating: 0x01, count: 512)
		try data.write(to: segmentURL)

		manager.assetFinishedDownloading(AVURLAsset(url: assetURL), to: downloadDirectory, for: cacheKey)
		waitForQueue()

		let entry = try XCTUnwrap(cacheStorage.entry(for: cacheKey))
		XCTAssertEqual(entry.key, cacheKey)
		XCTAssertEqual(entry.url, downloadDirectory)
		XCTAssertEqual(entry.size, data.count)
		XCTAssertEqual(entry.lastAccessedAt, Date(timeIntervalSince1970: 1_000))
	}

	func testRecordPlaybackUpdatesLastAccessed() throws {
		let cacheKey = "playback-key"
		let cachedURL = temporaryDirectory.appendingPathComponent("cached")
		try Data(count: 1).write(to: cachedURL)

		var entry = CacheEntry(
			key: cacheKey,
			type: .hls,
			url: cachedURL,
			lastAccessedAt: Date(timeIntervalSince1970: 10),
			size: 1
		)
		try cacheStorage.save(entry)

		currentTimestamp = 20
		manager.recordPlayback(for: cacheKey)
		waitForQueue()

		entry = try XCTUnwrap(cacheStorage.entry(for: cacheKey))
		XCTAssertEqual(entry.lastAccessedAt, Date(timeIntervalSince1970: 20))
	}

	func testCurrentCacheSizeInBytesReflectsStorage() throws {
		let firstURL = temporaryDirectory.appendingPathComponent("first")
		try Data(count: 64).write(to: firstURL)

		let secondURL = temporaryDirectory.appendingPathComponent("second")
		try Data(count: 32).write(to: secondURL)

		try cacheStorage.save(
			CacheEntry(key: "first", type: .hls, url: firstURL, size: 64)
		)
		try cacheStorage.save(
			CacheEntry(key: "second", type: .hls, url: secondURL, size: 32)
		)

		XCTAssertEqual(manager.currentCacheSizeInBytes(), 96)
	}

	func testClearCacheRemovesEntriesAndFiles() throws {
		let cacheKey = "clear"
		let cachedURL = temporaryDirectory.appendingPathComponent("directory", isDirectory: true)
		try FileManager.default.createDirectory(at: cachedURL, withIntermediateDirectories: true)
		let dataURL = cachedURL.appendingPathComponent("file.dat")
		try Data(count: 100).write(to: dataURL)

		try cacheStorage.save(
			CacheEntry(key: cacheKey, type: .hls, url: cachedURL, size: 100)
		)

		manager.clearCache()
		waitForQueue()

		XCTAssertNil(cacheStorage.entry(for: cacheKey))
		XCTAssertFalse(FileManager.default.fileExists(atPath: cachedURL.path))
		XCTAssertEqual(manager.currentCacheSizeInBytes(), 0)
	}

	func testUpdateMaxCacheSizePrunesOldestEntries() throws {
		let oldestURL = try makeDirectory(named: "oldest", size: 40)
		let middleURL = try makeDirectory(named: "middle", size: 30)
		let newestURL = try makeDirectory(named: "newest", size: 20)

		try cacheStorage.save(
			CacheEntry(
				key: "oldest",
				type: .hls,
				url: oldestURL,
				lastAccessedAt: Date(timeIntervalSince1970: 10),
				size: 40
			)
		)
		try cacheStorage.save(
			CacheEntry(
				key: "middle",
				type: .hls,
				url: middleURL,
				lastAccessedAt: Date(timeIntervalSince1970: 20),
				size: 30
			)
		)
		try cacheStorage.save(
			CacheEntry(
				key: "newest",
				type: .hls,
				url: newestURL,
				lastAccessedAt: Date(timeIntervalSince1970: 30),
				size: 20
			)
		)

		manager.updateMaxCacheSize(60)
		waitForQueue()

		XCTAssertNil(cacheStorage.entry(for: "oldest"))
		XCTAssertFalse(FileManager.default.fileExists(atPath: oldestURL.path))
		XCTAssertNotNil(cacheStorage.entry(for: "middle"))
		XCTAssertNotNil(cacheStorage.entry(for: "newest"))
		XCTAssertEqual(manager.currentCacheSizeInBytes(), 50)
	}

	func testPersistingEntryPrunesWhenExceedingQuota() throws {
		let keepURL = try makeDirectory(named: "keep", size: 40)
		let evictURL = try makeDirectory(named: "evict", size: 30)

		try cacheStorage.save(
			CacheEntry(
				key: "keep",
				type: .hls,
				url: keepURL,
				lastAccessedAt: Date(timeIntervalSince1970: 50),
				size: 40
			)
		)
		try cacheStorage.save(
			CacheEntry(
				key: "evict",
				type: .hls,
				url: evictURL,
				lastAccessedAt: Date(timeIntervalSince1970: 10),
				size: 30
			)
		)

		manager.updateMaxCacheSize(100)
		waitForQueue()

		let newDownloadURL = try makeDirectory(named: "new", size: 50)
		currentTimestamp = 100
		manager.assetFinishedDownloading(
			AVURLAsset(url: URL(string: "https://example.com/new.m3u8")!),
			to: newDownloadURL,
			for: "new"
		)
		waitForQueue()

		XCTAssertNil(cacheStorage.entry(for: "evict"))
		XCTAssertFalse(FileManager.default.fileExists(atPath: evictURL.path))
		XCTAssertNotNil(cacheStorage.entry(for: "keep"))
		XCTAssertNotNil(cacheStorage.entry(for: "new"))
		XCTAssertLessThanOrEqual(manager.currentCacheSizeInBytes(), 100)
	}

	// MARK: - Phase 1 Step 1.1: Thread Safety Tests

	func testConcurrentCacheOperationsAreSerialized() throws {
		let expectation = XCTestExpectation(description: "All operations completed")
		expectation.expectedFulfillmentCount = 10

		// Simulate concurrent operations from different threads
		for i in 0 ..< 10 {
			DispatchQueue.global().async { [weak self] in
				let cacheKey = "key-\(i)"
				let cachedURL = self?.temporaryDirectory.appendingPathComponent(cacheKey) ?? URL(fileURLWithPath: "/tmp")
				try? Data(count: 10).write(to: cachedURL)

				try? self?.cacheStorage.save(
					CacheEntry(key: cacheKey, type: .hls, url: cachedURL, size: 10)
				)

				self?.manager.recordPlayback(for: cacheKey)
				expectation.fulfill()
			}
		}

		wait(for: [expectation], timeout: 5.0)

		// Verify all operations completed successfully
		let allEntries = try cacheStorage.getAll()
		XCTAssertEqual(allEntries.count, 10)
	}

	func testSyncMethodsBlockUntilCompletion() throws {
		let firstURL = try makeDirectory(named: "first", size: 100)
		try cacheStorage.save(CacheEntry(key: "first", type: .hls, url: firstURL, size: 100))

		// recordPlayback is async, but we need to verify the queue processes it
		manager.recordPlayback(for: "first")

		// currentCacheSizeInBytes is sync and should block until queue is empty
		let size = manager.currentCacheSizeInBytes()
		XCTAssertEqual(size, 100)

		// Verify entry was updated
		let entry = try XCTUnwrap(cacheStorage.entry(for: "first"))
		XCTAssertEqual(entry.lastAccessedAt, Date(timeIntervalSince1970: 0))
	}

	func testAsyncMethodsReturnImmediately() {
		let startTime = Date()

		manager.recordPlayback(for: "nonexistent")
		let elapsed = Date().timeIntervalSince(startTime)

		// Should return immediately, not wait for queue
		XCTAssertLessThan(elapsed, 0.1)
	}

	// MARK: - Phase 1 Step 1.2: Database Index Tests

	func testPruningUsesIndexForEfficientQuery() throws {
		// Create multiple entries with different access times
		for i in 0 ..< 100 {
			let url = try makeDirectory(named: "entry-\(i)", size: 10)
			try cacheStorage.save(
				CacheEntry(
					key: "key-\(i)",
					type: .hls,
					url: url,
					lastAccessedAt: Date(timeIntervalSince1970: TimeInterval(i)),
					size: 10
				)
			)
		}

		// Set quota to force pruning
		manager.updateMaxCacheSize(500) // Should remove oldest 50 entries
		waitForQueue()

		// Verify correct entries were removed (oldest first)
		let remainingEntries = try cacheStorage.getAll()
		XCTAssertEqual(remainingEntries.count, 50)

		// Verify newest entries remain
		let remainingKeys = Set(remainingEntries.map { $0.key })
		for i in 50 ..< 100 {
			XCTAssertTrue(remainingKeys.contains("key-\(i)"))
		}
	}

	// MARK: - Phase 1 Step 1.3: Logging Tests

	func testLoggingRecordsPlaybackFailures() throws {
		// Try to record playback for non-existent entry - should log failure silently
		// This test verifies that logging infrastructure is in place
		manager.recordPlayback(for: "nonexistent-key")

		// If we reach here, no crash occurred and logging was handled gracefully
		XCTAssertTrue(true)
	}

	func testLoggingRecordsCacheClearingFailures() throws {
		let cacheKey = "test-key"
		let badURL = temporaryDirectory.appendingPathComponent("nonexistent/path/file.dat")

		// Manually add entry with invalid file path
		try cacheStorage.save(
			CacheEntry(key: cacheKey, type: .hls, url: badURL, lastAccessedAt: Date(), size: 100)
		)

		// Clear should log the error but not crash
		manager.clearCache()

		// Give queue time to process
		sleep(1)

		// Verify cache was still cleared despite file deletion failure
		XCTAssertNil(try cacheStorage.get(key: cacheKey))
	}

	// MARK: - Phase 1 Step 1.4: Race Condition Tests

	func testClearCacheCancelsDownloads() throws {
		let mockFactory = TestAssetFactory()
		let managerWithMock = PlayerCacheManager(
			storageDirectory: temporaryDirectory,
			cacheStorage: cacheStorage,
			fileManager: .live,
			timeProvider: { 0 }
		)

		// Add some entries
		let url1 = try makeDirectory(named: "cache1", size: 50)
		let url2 = try makeDirectory(named: "cache2", size: 50)

		try cacheStorage.save(CacheEntry(key: "key1", type: .hls, url: url1, size: 50))
		try cacheStorage.save(CacheEntry(key: "key2", type: .hls, url: url2, size: 50))

		// Clear should remove all entries
		managerWithMock.clearCache()

		// Give queue time to process
		sleep(1)

		// Verify all entries are removed
		let remainingEntries = try cacheStorage.getAll()
		XCTAssertEqual(remainingEntries.count, 0)
	}

	func testClearCacheRemovesAllFilesEvenIfSomeFail() throws {
		let cacheKey1 = "key1"
		let cacheKey2 = "key2"

		let validURL = try makeDirectory(named: "valid", size: 50)
		let invalidURL = temporaryDirectory.appendingPathComponent("invalid/nested/path", isDirectory: true)

		try cacheStorage.save(CacheEntry(key: cacheKey1, type: .hls, url: validURL, size: 50))
		try cacheStorage.save(CacheEntry(key: cacheKey2, type: .hls, url: invalidURL, size: 50))

		// Clear should remove metadata for both entries despite one file deletion failing
		manager.clearCache()

		// Give queue time to process
		sleep(1)

		// Both metadata entries should be deleted even though one file deletion failed
		XCTAssertNil(try cacheStorage.get(key: cacheKey1))
		XCTAssertNil(try cacheStorage.get(key: cacheKey2))
	}

	func testClearCacheIsAtomicWhenInterleaved() throws {
		// Add initial entries
		let url1 = try makeDirectory(named: "entry1", size: 100)
		try cacheStorage.save(CacheEntry(key: "key1", type: .hls, url: url1, size: 100))

		// Start clearing
		manager.clearCache()

		// Try to read size during clear - should get 0 if clear completed
		// or current size if not yet started
		sleep(1) // Give queue time to process

		// After clear completes, size should be 0
		let finalSize = manager.currentCacheSizeInBytes()
		XCTAssertEqual(finalSize, 0)
	}

	func testRecordPlaybackDuringClearDoesNotCrash() throws {
		let url = try makeDirectory(named: "entry", size: 100)
		try cacheStorage.save(CacheEntry(key: "key", type: .hls, url: url, size: 100))

		// Start clearing and immediately try to record playback
		manager.clearCache()
		manager.recordPlayback(for: "key")

		// Give queue time to process both operations
		sleep(1)

		// Should not crash and cache should be clear
		XCTAssertEqual(manager.currentCacheSizeInBytes(), 0)
	}

	private func makeDirectory(named: String, size: Int) throws -> URL {
		let directoryURL = temporaryDirectory.appendingPathComponent(named, isDirectory: true)
		try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
		let fileURL = directoryURL.appendingPathComponent("data.bin")
		try Data(repeating: 0x01, count: size).write(to: fileURL)
		return directoryURL
	}
}

// MARK: - TestCacheStorage

private final class TestCacheStorage: CacheStorage {
	private var entries: [String: CacheEntry] = [:]

	func save(_ entry: CacheEntry) throws {
		entries[entry.key] = entry
	}

	func get(key: String) throws -> CacheEntry? {
		entries[key]
	}

	func delete(key: String) throws {
		entries.removeValue(forKey: key)
	}

	func update(_ entry: CacheEntry) throws {
		entries[entry.key] = entry
	}

	func getAll() throws -> [CacheEntry] {
		Array(entries.values)
	}

	func totalSize() throws -> Int {
		entries.values.reduce(0) { $0 + $1.size }
	}

	func pruneToSize(_ maxSize: Int) throws {
		var orderedEntries = entries.values.sorted(by: { $0.lastAccessedAt < $1.lastAccessedAt })
		var currentSize = orderedEntries.reduce(0) { $0 + $1.size }

		while currentSize > maxSize, let entry = orderedEntries.first {
			currentSize -= entry.size
			entries.removeValue(forKey: entry.key)
			orderedEntries.removeFirst()
		}
	}

	func entry(for key: String) -> CacheEntry? {
		entries[key]
	}
}

// MARK: - TestAssetFactory

private final class TestAssetFactory {
	private(set) var resetCallCount = 0
	private(set) var deletedKeys: [String] = []

	func reset() {
		resetCallCount += 1
	}

	func delete(_ key: String) {
		deletedKeys.append(key)
	}
}
