import AVFoundation
import Foundation
import GRDB

// MARK: - Protocols

public protocol PlayerCacheManagerDelegate: AnyObject {
	func playerCacheManager(
		_ manager: PlayerCacheManaging,
		didFinishDownloading urlAsset: AVURLAsset,
		to location: URL,
		for cacheKey: String
	)
}

public protocol PlayerCacheManaging: AnyObject {
	var delegate: PlayerCacheManagerDelegate? { get set }

	func prepareCache(isEnabled: Bool)
	func resolveAsset(for url: URL, cacheKey: String?) -> PlayerCacheResult
	func startCachingIfNeeded(_ urlAsset: AVURLAsset, cacheState: AssetCacheState?)
	func cancelDownload(for cacheKey: String)
	func recordPlayback(for cacheKey: String)
	func currentCacheSizeInBytes() -> Int
	func clearCache()
	func updateMaxCacheSize(_ sizeInBytes: Int?)
	func reset()
}

// MARK: - Result

public struct PlayerCacheResult {
	public let urlAsset: AVURLAsset
	public let cacheState: AssetCacheState?

	public init(urlAsset: AVURLAsset, cacheState: AssetCacheState?) {
		self.urlAsset = urlAsset
		self.cacheState = cacheState
	}
}

// MARK: - PlayerCacheManager

final class PlayerCacheManager: PlayerCacheManaging {
	public weak var delegate: PlayerCacheManagerDelegate?

	private let assetFactory: AVURLAssetFactory
	private let cacheStorage: any CacheStorage
	private let storageDirectory: URL
	private let fileManager: FileManagerClient
 	private let timeProvider: () -> UInt64
 	private var maxCacheSizeInBytes: Int?

	private enum Constants {
		static let cacheDatabaseFilename = "player-cache.sqlite"
	}

	init(
		storageDirectory: URL? = nil,
		cacheStorage: (any CacheStorage)? = nil,
		fileManager: FileManagerClient = .live,
		timeProvider: @escaping () -> UInt64 = { PlayerWorld.timeProvider.timestamp() },
		maxCacheSizeInBytes: Int? = nil
	) {
		self.fileManager = fileManager
		self.timeProvider = timeProvider
 		self.maxCacheSizeInBytes = maxCacheSizeInBytes

	let resolvedDirectory = storageDirectory ?? fileManager.cachesDirectory()
	PlayerCacheManager.ensureDirectoryExists(at: resolvedDirectory, fileManager: fileManager)
	self.storageDirectory = resolvedDirectory

	let assetCache = AssetCache(storageDirectory: resolvedDirectory)

	assetFactory = AVURLAssetFactory(assetCache: assetCache)
		self.cacheStorage = cacheStorage ?? PlayerCacheManager.makeCacheStorage(
			at: resolvedDirectory,
			fileManager: fileManager
		)

		self.assetFactory.delegate = self
	}

	public func prepareCache(isEnabled: Bool) {
		if !isEnabled {
			assetFactory.clearCache()
		}
	}

	public func resolveAsset(for url: URL, cacheKey: String?) -> PlayerCacheResult {
		guard let cacheKey else {
			return PlayerCacheResult(
				urlAsset: AVURLAsset(
					url: url,
					options: [AVURLAssetPreferPreciseDurationAndTimingKey: url.isFileURL]
				),
				cacheState: nil
			)
		}

		var cacheState = assetFactory.get(with: cacheKey)
		let urlAsset: AVURLAsset

		switch cacheState {
		case .none:
			urlAsset = AVURLAsset(
				url: url,
				options: [AVURLAssetPreferPreciseDurationAndTimingKey: url.isFileURL]
			)
		case let .some(state):
			switch state.status {
			case .notCached:
				urlAsset = AVURLAsset(url: url)
				cacheState = state
				removeCacheEntry(for: state.key)
			case let .cached(cachedURL):
				let cachedAsset = AVURLAsset(url: cachedURL)
				if cachedAsset.isPlayableOffline {
					urlAsset = cachedAsset
					cacheState = state
					persistCacheEntryIfNeeded(for: state.key, at: cachedURL)
				} else {
					removeCacheEntry(for: state.key)
					assetFactory.delete(state.key)
					let fallbackState = AssetCacheState(key: state.key, status: .notCached)
					cacheState = fallbackState
					urlAsset = AVURLAsset(url: url)
				}
			}
		}

		return PlayerCacheResult(urlAsset: urlAsset, cacheState: cacheState)
	}

	public func startCachingIfNeeded(_ urlAsset: AVURLAsset, cacheState: AssetCacheState?) {
		guard let cacheState else {
			return
		}

		switch cacheState.status {
		case .notCached:
			assetFactory.cacheAsset(urlAsset, for: cacheState.key)
	case .cached:
		if let cachedURL = cacheState.cachedURL {
			persistCacheEntryIfNeeded(for: cacheState.key, at: cachedURL)
		}
	}
}

	public func cancelDownload(for cacheKey: String) {
		assetFactory.cancel(with: cacheKey)
	}

	public func recordPlayback(for cacheKey: String) {
		do {
			guard var entry = try cacheStorage.get(key: cacheKey) else {
				return
			}
			entry.lastAccessedAt = currentDate()
			try cacheStorage.update(entry)
		} catch {
			// Intentionally ignored for now; logging can be added once requirements are defined.
		}
	}

	public func currentCacheSizeInBytes() -> Int {
		do {
			return try cacheStorage.totalSize()
		} catch {
			return 0
		}
	}

	public func clearCache() {
		do {
			let entries = try cacheStorage.getAll()
			for entry in entries {
				assetFactory.delete(entry.key)
				removePhysicalFileIfNeeded(at: entry.url)
				try cacheStorage.delete(key: entry.key)
			}
			assetFactory.reset()
		} catch {
			// Intentionally ignored for now; logging can be added once requirements are defined.
		}
	}

	public func updateMaxCacheSize(_ sizeInBytes: Int?) {
		maxCacheSizeInBytes = sizeInBytes
		pruneCacheIfNeeded()
	}

	public func reset() {
		assetFactory.reset()
	}
}

// MARK: - AssetFactoryDelegate

extension PlayerCacheManager: AssetFactoryDelegate {
	func assetFinishedDownloading(_ urlAsset: AVURLAsset, to location: URL, for cacheKey: String) {
		persistCacheEntryIfNeeded(for: cacheKey, at: location)
		delegate?.playerCacheManager(
			self,
			didFinishDownloading: urlAsset,
			to: location,
			for: cacheKey
		)
	}
}

// MARK: - Helpers

private extension PlayerCacheManager {
	static func ensureDirectoryExists(at directory: URL, fileManager: FileManagerClient) {
		var isDirectory = ObjCBool(false)
		let path = directory.path
		if !fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
			try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
		} else if !isDirectory.boolValue {
			try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
		}
	}

	static func makeCacheStorage(at directory: URL, fileManager: FileManagerClient) -> any CacheStorage {
		let databaseURL = directory.appendingPathComponent(Constants.cacheDatabaseFilename, isDirectory: false)
		do {
			let dbQueue = try DatabaseQueue(path: databaseURL.path)
			return GRDBCacheStorage(dbQueue: dbQueue)
		} catch {
			return InMemoryCacheStorage()
		}
	}

	func persistCacheEntryIfNeeded(for cacheKey: String, at url: URL) {
		guard let size = calculateSize(of: url) else {
			return
		}

		do {
			if var existingEntry = try cacheStorage.get(key: cacheKey) {
				existingEntry.url = url
				existingEntry.size = size
				existingEntry.lastAccessedAt = currentDate()
				try cacheStorage.update(existingEntry)
			} else {
				let entry = CacheEntry(
					key: cacheKey,
					type: .hls,
					url: url,
					lastAccessedAt: currentDate(),
					size: size
				)
				try cacheStorage.save(entry)
			}
		} catch {
			// Intentionally ignored for now; logging can be added once requirements are defined.
		}

		pruneCacheIfNeeded()
	}

	func removeCacheEntry(for cacheKey: String) {
		try? cacheStorage.delete(key: cacheKey)
	}

	func calculateSize(of url: URL) -> Int? {
		var isDirectory = ObjCBool(false)
		if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue {
			do {
				let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
				return contents.reduce(0) { partialResult, fileURL in
					partialResult + (calculateSize(of: fileURL) ?? 0)
				}
			} catch {
				return nil
			}
		}

		do {
			let attributes = try fileManager.attributesOfItem(url.path)
		return (attributes[.size] as? NSNumber)?.intValue ?? 0
	} catch {
		return nil
	}
}

	func removePhysicalFileIfNeeded(at url: URL) {
		guard url.path.hasPrefix(storageDirectory.path) else {
			return
		}
		try? fileManager.removeItem(at: url)
	}

	func pruneCacheIfNeeded() {
		guard let maxCacheSizeInBytes, maxCacheSizeInBytes >= 0 else {
			return
		}

		do {
			let entries = try cacheStorage.getAll().sorted(by: { $0.lastAccessedAt < $1.lastAccessedAt })
			var currentSize = entries.reduce(0) { $0 + $1.size }

			var index = 0
			while currentSize > maxCacheSizeInBytes, index < entries.count {
				let entry = entries[index]
				assetFactory.delete(entry.key)
				removePhysicalFileIfNeeded(at: entry.url)
				try cacheStorage.delete(key: entry.key)
				currentSize -= entry.size
				index += 1
			}
		} catch {
			// Intentionally ignored for now; logging can be added once requirements are defined.
		}
	}

	func currentDate() -> Date {
		Date(timeIntervalSince1970: TimeInterval(timeProvider()) / 1000.0)
	}
}

// MARK: - InMemoryCacheStorage

private final class InMemoryCacheStorage: CacheStorage {
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
		var sortedEntries = entries.values.sorted(by: { $0.lastAccessedAt < $1.lastAccessedAt })
		var currentSize = sortedEntries.reduce(0) { $0 + $1.size }

		while currentSize > maxSize, let entry = sortedEntries.first {
			currentSize -= entry.size
			entries.removeValue(forKey: entry.key)
			sortedEntries.removeFirst()
		}
	}
}

private extension AssetCacheState {
	var cachedURL: URL? {
		if case let .cached(cachedURL) = status {
			return cachedURL
		}
		return nil
	}
}
