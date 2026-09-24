import AVFoundation
@testable import Player
import XCTest

// MARK: - PlayerCacheManagerTests

final class PlayerCacheManagerTests: XCTestCase {
	private var temporaryDirectory: URL!
	private var cacheStorage: TestCacheStorage!
	private var manager: PlayerCacheManager!
	private var currentTimestamp: UInt64!
	private var loggedEvents: [CacheLoggable]!

	override func setUpWithError() throws {
		try super.setUpWithError()

		currentTimestamp = 0
		cacheStorage = TestCacheStorage()
		loggedEvents = []

		let baseDirectory = FileManager.default.temporaryDirectory
		temporaryDirectory = baseDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
		try FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)

		manager = PlayerCacheManager(
			storageDirectory: temporaryDirectory,
			cacheStorage: cacheStorage,
			fileManager: .live,
			timeProvider: { [weak self] in
				self?.currentTimestamp ?? 0
			},
			logHandler: { [weak self] event in
				self?.loggedEvents.append(event)
			}
		)
	}

	override func tearDownWithError() throws {
		try? FileManager.default.removeItem(at: temporaryDirectory)
		manager = nil
		cacheStorage = nil
		temporaryDirectory = nil
		currentTimestamp = nil
		loggedEvents = nil

		try super.tearDownWithError()
	}

	private func waitForQueue() {
		_ = manager.currentCacheSizeInBytes()
	}

	func testPersistEntryOnDownload() throws {
		currentTimestamp = 1_000_000

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
		XCTAssertEqual(entry.lastAccessedAt, Date(timeIntervalSince1970: 1000))
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

		currentTimestamp = 20000
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
		currentTimestamp = 100_000
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
		let expectation = XCTestExpectation(description: "All operations submitted")
		expectation.expectedFulfillmentCount = 10
		currentTimestamp = 20000

		for i in 0 ..< 10 {
			let cacheKey = "key-\(i)"
			let cachedURL = temporaryDirectory.appendingPathComponent(cacheKey)
			try Data(count: 10).write(to: cachedURL)
			try cacheStorage.save(CacheEntry(key: cacheKey, type: .hls, url: cachedURL, size: 10))
		}

		for i in 0 ..< 10 {
			DispatchQueue.global().async { [weak self] in
				self?.manager.recordPlayback(for: "key-\(i)")
				expectation.fulfill()
			}
		}

		wait(for: [expectation], timeout: 5.0)
		waitForQueue()

		let allEntries = try cacheStorage.getAll()
		XCTAssertEqual(allEntries.count, 10)
		XCTAssertTrue(allEntries.allSatisfy { $0.lastAccessedAt == Date(timeIntervalSince1970: 20) })
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
		cacheStorage.getError = TestError.forced

		manager.recordPlayback(for: "failed-key")
		waitForQueue()

		guard case let .recordPlaybackFailed(cacheKey, error) = try XCTUnwrap(loggedEvents.first) else {
			return XCTFail("Expected a recordPlaybackFailed event")
		}
		XCTAssertEqual(cacheKey, "failed-key")
		XCTAssertEqual(error as? TestError, .forced)
	}

	func testLoggingRecordsCacheClearingFailures() throws {
		let cachedURL = try makeDirectory(named: "failed-clear", size: 100)
		try cacheStorage.save(CacheEntry(key: "failed-key", type: .hls, url: cachedURL, size: 100))
		cacheStorage.deleteError = TestError.forced

		manager.clearCache()
		waitForQueue()

		guard case let .clearCacheFailed(error) = try XCTUnwrap(loggedEvents.first) else {
			return XCTFail("Expected a clearCacheFailed event")
		}
		XCTAssertEqual(error as? TestError, .forced)
	}

	// MARK: - Phase 1 Step 1.4: Race Condition Tests

	func testClearCacheCancelsDownloadsBeforeDeletingEntries() throws {
		let mockFactory = TestAssetFactory()
		let managerWithMock = PlayerCacheManager(
			storageDirectory: temporaryDirectory,
			cacheStorage: cacheStorage,
			assetFactory: mockFactory,
			fileManager: .live,
			timeProvider: { 0 }
		)
		let url1 = try makeDirectory(named: "cache1", size: 50)
		let url2 = try makeDirectory(named: "cache2", size: 50)
		try cacheStorage.save(CacheEntry(key: "key1", type: .hls, url: url1, size: 50))
		try cacheStorage.save(CacheEntry(key: "key2", type: .hls, url: url2, size: 50))

		managerWithMock.clearCache()
		_ = managerWithMock.currentCacheSizeInBytes()

		XCTAssertEqual(mockFactory.events.first, .reset)
		XCTAssertEqual(Set(mockFactory.deletedKeys), ["key1", "key2"])
		XCTAssertTrue(try cacheStorage.getAll().isEmpty)
	}

	func testClearCacheRemovesAllFilesEvenIfSomeFail() throws {
		let failingURL = try makeDirectory(named: "failing", size: 50)
		let removableURL = try makeDirectory(named: "removable", size: 50)
		try cacheStorage.save(CacheEntry(key: "failing", type: .hls, url: failingURL, size: 50))
		try cacheStorage.save(CacheEntry(key: "removable", type: .hls, url: removableURL, size: 50))

		var fileManager = FileManagerClient.live
		fileManager.removeFile = { url in
			if url == failingURL {
				throw TestError.forced
			}
			try FileManager.default.removeItem(at: url)
		}
		let managerWithFailingRemoval = PlayerCacheManager(
			storageDirectory: temporaryDirectory,
			cacheStorage: cacheStorage,
			fileManager: fileManager,
			logHandler: { [weak self] event in
				self?.loggedEvents.append(event)
			}
		)

		managerWithFailingRemoval.clearCache()
		_ = managerWithFailingRemoval.currentCacheSizeInBytes()

		XCTAssertTrue(try cacheStorage.getAll().isEmpty)
		XCTAssertTrue(FileManager.default.fileExists(atPath: failingURL.path))
		XCTAssertFalse(FileManager.default.fileExists(atPath: removableURL.path))
		XCTAssertTrue(loggedEvents.contains {
			guard case .deleteCacheFileFailed = $0 else {
				return false
			}
			return true
		})
	}

	func testClearCacheIsAtomicWhenInterleaved() throws {
		// Add initial entries
		let url1 = try makeDirectory(named: "entry1", size: 100)
		try cacheStorage.save(CacheEntry(key: "key1", type: .hls, url: url1, size: 100))

		// Start clearing
		manager.clearCache()

		let finalSize = manager.currentCacheSizeInBytes()
		XCTAssertEqual(finalSize, 0)
	}

	func testRecordPlaybackDuringClearDoesNotCrash() throws {
		let url = try makeDirectory(named: "entry", size: 100)
		try cacheStorage.save(CacheEntry(key: "key", type: .hls, url: url, size: 100))

		// Start clearing and immediately try to record playback
		manager.clearCache()
		manager.recordPlayback(for: "key")

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

// MARK: - TestError

private enum TestError: Error {
	case forced
}

// MARK: - TestCacheStorage

private final class TestCacheStorage: CacheStorage {
	private var entries: [String: CacheEntry] = [:]
	var getError: Error?
	var deleteError: Error?

	func save(_ entry: CacheEntry) throws {
		entries[entry.key] = entry
	}

	func get(key: String) throws -> CacheEntry? {
		if let getError {
			throw getError
		}
		return entries[key]
	}

	func delete(key: String) throws {
		if let deleteError {
			throw deleteError
		}
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

private final class TestAssetFactory: AssetFactoring {
	enum Event: Equatable {
		case reset
		case delete(String)
	}

	weak var delegate: AssetFactoryDelegate?
	private(set) var events: [Event] = []
	var deletedKeys: [String] {
		events.compactMap {
			guard case let .delete(key) = $0 else {
				return nil
			}
			return key
		}
	}

	func get(with cacheKey: String?) -> AssetCacheState? {
		cacheKey.map { AssetCacheState(key: $0, status: .notCached) }
	}

	func delete(_ key: String) {
		events.append(.delete(key))
	}

	func cacheAsset(_: AVURLAsset, for _: String) {}

	func cancel(with _: String) {}

	func reset() {
		events.append(.reset)
	}

	func clearCache() {}
}
