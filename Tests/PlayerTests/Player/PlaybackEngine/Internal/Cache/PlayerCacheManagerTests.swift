import AVFoundation
@testable import Player
import XCTest

// MARK: - PlayerCacheManagerTests

final class PlayerCacheManagerTests: XCTestCase {
	private var temporaryDirectory: URL!
	private var cacheStorage: TestCacheStorage!
	private var manager: PlayerCacheManager!
	private var currentDate: Date!

	override func setUpWithError() throws {
		try super.setUpWithError()

		currentDate = Date()
		cacheStorage = TestCacheStorage()

		let baseDirectory = FileManager.default.temporaryDirectory
		temporaryDirectory = baseDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
		try FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)

		manager = PlayerCacheManager(
			storageDirectory: temporaryDirectory,
			cacheStorage: cacheStorage,
			fileManager: .live,
			dateProvider: { [weak self] in
				self?.currentDate ?? Date()
			}
		)
	}

	override func tearDownWithError() throws {
		try? FileManager.default.removeItem(at: temporaryDirectory)
		manager = nil
		cacheStorage = nil
		temporaryDirectory = nil
		currentDate = nil

		try super.tearDownWithError()
	}

	func testPersistEntryOnDownload() throws {
		currentDate = Date(timeIntervalSince1970: 1000)

		let cacheKey = "test-cache-key"
		let assetURL = URL(string: "https://example.com/stream.m3u8")!
		let downloadDirectory = temporaryDirectory.appendingPathComponent("download", isDirectory: true)
		try FileManager.default.createDirectory(at: downloadDirectory, withIntermediateDirectories: true)

		let segmentURL = downloadDirectory.appendingPathComponent("segment.ts")
		let data = Data(repeating: 0x01, count: 512)
		try data.write(to: segmentURL)

		manager.assetFinishedDownloading(AVURLAsset(url: assetURL), to: downloadDirectory, for: cacheKey)

		let entry = try XCTUnwrap(cacheStorage.entry(for: cacheKey))
		XCTAssertEqual(entry.key, cacheKey)
		XCTAssertEqual(entry.url, downloadDirectory)
		XCTAssertEqual(entry.size, data.count)
		XCTAssertEqual(entry.lastAccessedAt, currentDate)
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

		currentDate = Date(timeIntervalSince1970: 20)
		manager.recordPlayback(for: cacheKey)

		entry = try XCTUnwrap(cacheStorage.entry(for: cacheKey))
		XCTAssertEqual(entry.lastAccessedAt, currentDate)
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

		let newDownloadURL = try makeDirectory(named: "new", size: 50)
		currentDate = Date(timeIntervalSince1970: 100)
		manager.assetFinishedDownloading(
			AVURLAsset(url: URL(string: "https://example.com/new.m3u8")!),
			to: newDownloadURL,
			for: "new"
		)

		XCTAssertNil(cacheStorage.entry(for: "evict"))
		XCTAssertFalse(FileManager.default.fileExists(atPath: evictURL.path))
		XCTAssertNotNil(cacheStorage.entry(for: "keep"))
		XCTAssertNotNil(cacheStorage.entry(for: "new"))
		XCTAssertLessThanOrEqual(manager.currentCacheSizeInBytes(), 100)
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
