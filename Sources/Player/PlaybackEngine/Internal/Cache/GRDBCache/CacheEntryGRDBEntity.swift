import Foundation
import GRDB

// MARK: - CacheEntryType + DatabaseValueConvertible

extension CacheEntryType: DatabaseValueConvertible {}

// MARK: - CacheEntryGRDBEntity

struct CacheEntryGRDBEntity: Codable, FetchableRecord, PersistableRecord {
	let key: String
	let type: CacheEntryType
	let mediaBookmark: Data?
	let lastAccessedAt: Date
	let size: Int

	var cacheEntry: CacheEntry {
		CacheEntry(key: key, type: type, url: mediaURL, lastAccessedAt: lastAccessedAt, size: size)
	}

	private var mediaURL: URL? {
		var isStale = false
		guard
			let mediaBookmark,
			let url = try? URL(resolvingBookmarkData: mediaBookmark, bookmarkDataIsStale: &isStale)
		else {
			return nil
		}
		return url
	}

	static let databaseTableName = "cacheEntries"

	enum Columns {
		static let key = Column(CodingKeys.key)
		static let type = Column(CodingKeys.type)
		static let mediaBookmark = Column(CodingKeys.mediaBookmark)
		static let lastAccessedAt = Column(CodingKeys.lastAccessedAt)
		static let size = Column(CodingKeys.size)
	}

	init(key: String, type: CacheEntryType, mediaURL: URL?, lastAccessedAt: Date = Date.now, size: Int) {
		self.key = key
		self.type = type
		mediaBookmark = try? mediaURL?.bookmarkData()
		self.lastAccessedAt = lastAccessedAt
		self.size = size
	}

	init(from entry: CacheEntry) {
		key = entry.key
		type = entry.type
		mediaBookmark = try? entry.url?.bookmarkData()
		lastAccessedAt = entry.lastAccessedAt
		size = entry.size
	}

	func bookmarkDataNeedsUpdating() -> Bool {
		guard let mediaBookmark else {
			return false
		}

		do {
			var isStale = false
			_ = try URL(resolvingBookmarkData: mediaBookmark, bookmarkDataIsStale: &isStale)
			return isStale
		} catch {
			return false
		}
	}
}
