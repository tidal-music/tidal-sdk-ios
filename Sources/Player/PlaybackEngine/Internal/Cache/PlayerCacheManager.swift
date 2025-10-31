import AVFoundation
import Foundation
import GRDB
import Logging

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

/// Thread-safe cache manager for coordinating media asset downloads.
///
/// All public methods are thread-safe and can be called from any thread.
/// The manager uses a serial OperationQueue to ensure all cache operations
/// execute sequentially, matching the concurrency pattern used throughout
/// the Player SDK (see PlayerEngine for a similar implementation).
///
/// - Important: Async methods like ``recordPlayback(for:)`` and ``clearCache()``
///   dispatch work to the queue and return immediately. Sync methods like
///   ``resolveAsset(for:cacheKey:)`` block the calling thread until the operation
///   completes, but do not block other cache operations (serialized on the queue).
///
/// Example:
/// ```swift
/// // Safe to call from any thread
/// DispatchQueue.global().async {
///     manager.recordPlayback(for: cacheKey)
/// }
///
/// // Blocks until complete
/// let result = manager.resolveAsset(for: url, cacheKey: cacheKey)
/// ```
final class PlayerCacheManager: PlayerCacheManaging {
	public weak var delegate: PlayerCacheManagerDelegate?

	private let assetFactory: AVURLAssetFactory
	private let cacheStorage: any CacheStorage
	private let storageDirectory: URL
	private let fileManager: FileManagerClient
 	private let timeProvider: () -> UInt64
 	private var maxCacheSizeInBytes: Int?

	/// Logger for cache operations. Uses PlayerWorld.logger if available.
	private var logger: TidalLogger?

	/// Serial OperationQueue for thread-safe access to cache operations.
	/// Matches the concurrency pattern used in PlayerEngine and other
	/// core Player components.
	private let queue = OperationQueue()

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

		// Initialize logger from PlayerWorld if available
		self.logger = PlayerWorld.logger

		// Configure serial queue (matches PlayerEngine pattern)
		queue.maxConcurrentOperationCount = 1
		queue.qualityOfService = .utility
		queue.name = "com.tidal.player.cache"

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
		queue.addOperation { [weak self] in
			self?._prepareCache(isEnabled: isEnabled)
		}
	}

	private func _prepareCache(isEnabled: Bool) {
		if !isEnabled {
			assetFactory.clearCache()
		}
	}

	public func resolveAsset(for url: URL, cacheKey: String?) -> PlayerCacheResult {
		var result: PlayerCacheResult?
		let operation = BlockOperation { [weak self] in
			result = self?._resolveAsset(for: url, cacheKey: cacheKey)
		}
		queue.addOperation(operation)
		operation.waitUntilFinished()
		return result ?? PlayerCacheResult(urlAsset: AVURLAsset(url: url), cacheState: nil)
	}

	private func _resolveAsset(for url: URL, cacheKey: String?) -> PlayerCacheResult {
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
				_removeCacheEntry(for: state.key)
			case let .cached(cachedURL):
				let cachedAsset = AVURLAsset(url: cachedURL)
				if cachedAsset.isPlayableOffline {
					urlAsset = cachedAsset
					cacheState = state
					_persistCacheEntryIfNeeded(for: state.key, at: cachedURL)
				} else {
					_removeCacheEntry(for: state.key)
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
		queue.addOperation { [weak self] in
			self?._startCachingIfNeeded(urlAsset, cacheState: cacheState)
		}
	}

	private func _startCachingIfNeeded(_ urlAsset: AVURLAsset, cacheState: AssetCacheState?) {
		guard let cacheState else {
			return
		}

		switch cacheState.status {
		case .notCached:
			assetFactory.cacheAsset(urlAsset, for: cacheState.key)
		case .cached:
			if let cachedURL = cacheState.cachedURL {
				_persistCacheEntryIfNeeded(for: cacheState.key, at: cachedURL)
			}
		}
	}

	public func cancelDownload(for cacheKey: String) {
		queue.addOperation { [weak self] in
			self?.assetFactory.cancel(with: cacheKey)
		}
	}

	public func recordPlayback(for cacheKey: String) {
		queue.addOperation { [weak self] in
			self?._recordPlayback(for: cacheKey)
		}
	}

	private func _recordPlayback(for cacheKey: String) {
		do {
			guard var entry = try cacheStorage.get(key: cacheKey) else {
				return
			}
			entry.lastAccessedAt = _currentDate()
			try cacheStorage.update(entry)
		} catch {
			logger?.log(loggable: CacheLoggable.recordPlaybackFailed(cacheKey: cacheKey, error: error))
		}
	}

	public func currentCacheSizeInBytes() -> Int {
		var result = 0
		let operation = BlockOperation { [weak self] in
			result = self?._currentCacheSizeInBytes() ?? 0
		}
		queue.addOperation(operation)
		operation.waitUntilFinished()
		return result
	}

	private func _currentCacheSizeInBytes() -> Int {
		do {
			return try cacheStorage.totalSize()
		} catch {
			return 0
		}
	}

	public func clearCache() {
		queue.addOperation { [weak self] in
			self?._clearCacheAtomically()
		}
	}

	private func _clearCacheAtomically() {
		// Step 1: Cancel all in-progress downloads first
		// This prevents new entries from being added to cache during clearing
		assetFactory.reset()

		// Step 2: Delete all cache entries and their associated files
		do {
			let entries = try cacheStorage.getAll()
			for entry in entries {
				assetFactory.delete(entry.key)
				do {
					try _removePhysicalFileIfNeeded(at: entry.url)
				} catch {
					logger?.log(loggable: CacheLoggable.deleteCacheFileFailed(fileName: entry.url.lastPathComponent, error: error))
					// Continue clearing other entries even if file deletion fails
				}
				try cacheStorage.delete(key: entry.key)
			}
		} catch {
			logger?.log(loggable: CacheLoggable.clearCacheFailed(error: error))
		}
	}

	public func updateMaxCacheSize(_ sizeInBytes: Int?) {
		queue.addOperation { [weak self] in
			self?._updateMaxCacheSize(sizeInBytes)
		}
	}

	private func _updateMaxCacheSize(_ sizeInBytes: Int?) {
		maxCacheSizeInBytes = sizeInBytes
		_pruneCacheIfNeeded()
	}

	public func reset() {
		queue.addOperation { [weak self] in
			self?.assetFactory.reset()
		}
	}
}

// MARK: - AssetFactoryDelegate

extension PlayerCacheManager: AssetFactoryDelegate {
	func assetFinishedDownloading(_ urlAsset: AVURLAsset, to location: URL, for cacheKey: String) {
		queue.addOperation { [weak self] in
			self?._persistCacheEntryIfNeeded(for: cacheKey, at: location)
			self?.delegate?.playerCacheManager(
				self!,
				didFinishDownloading: urlAsset,
				to: location,
				for: cacheKey
			)
		}
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

	func _persistCacheEntryIfNeeded(for cacheKey: String, at url: URL) {
		guard let size = _calculateSize(of: url) else {
			return
		}

		do {
			if var existingEntry = try cacheStorage.get(key: cacheKey) {
				existingEntry.url = url
				existingEntry.size = size
				existingEntry.lastAccessedAt = _currentDate()
				try cacheStorage.update(existingEntry)
			} else {
				let entry = CacheEntry(
					key: cacheKey,
					type: .hls,
					url: url,
					lastAccessedAt: _currentDate(),
					size: size
				)
				try cacheStorage.save(entry)
			}
		} catch {
			logger?.log(loggable: CacheLoggable.persistCacheEntryFailed(cacheKey: cacheKey, error: error))
		}

		_pruneCacheIfNeeded()
	}

	func _removeCacheEntry(for cacheKey: String) {
		try? cacheStorage.delete(key: cacheKey)
	}

	func _calculateSize(of url: URL) -> Int? {
		var isDirectory = ObjCBool(false)
		if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue {
			do {
				let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
				return contents.reduce(0) { partialResult, fileURL in
					partialResult + (_calculateSize(of: fileURL) ?? 0)
				}
			} catch {
				logger?.log(loggable: CacheLoggable.calculateSizeFailed(url: url, error: error))
				return nil
			}
		}

		do {
			let attributes = try fileManager.attributesOfItem(url.path)
			return (attributes[.size] as? NSNumber)?.intValue ?? 0
		} catch {
			logger?.log(loggable: CacheLoggable.calculateSizeFailed(url: url, error: error))
			return nil
		}
	}

	func _removePhysicalFileIfNeeded(at url: URL) throws {
		guard url.path.hasPrefix(storageDirectory.path) else {
			return
		}
		try fileManager.removeItem(at: url)
	}

	func _pruneCacheIfNeeded() {
		guard let maxCacheSizeInBytes, maxCacheSizeInBytes >= 0 else {
			return
		}

		do {
			let entries = try cacheStorage.getAll().sorted(by: { $0.lastAccessedAt < $1.lastAccessedAt })
			var currentSize = entries.reduce(0) { $0 + $1.size }

			guard currentSize > maxCacheSizeInBytes else { return }

			logger?.log(loggable: CacheLoggable.pruningStarted(currentSize: currentSize, targetSize: maxCacheSizeInBytes))

			var entriesRemoved = 0
			var index = 0
			while currentSize > maxCacheSizeInBytes, index < entries.count {
				let entry = entries[index]
				assetFactory.delete(entry.key)
				try _removePhysicalFileIfNeeded(at: entry.url)
				try cacheStorage.delete(key: entry.key)
				currentSize -= entry.size
				entriesRemoved += 1
				index += 1
			}

			logger?.log(loggable: CacheLoggable.pruningCompleted(newSize: currentSize, entriesRemoved: entriesRemoved))
		} catch {
			logger?.log(loggable: CacheLoggable.pruneFailed(error: error))
		}
	}

	func _currentDate() -> Date {
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
