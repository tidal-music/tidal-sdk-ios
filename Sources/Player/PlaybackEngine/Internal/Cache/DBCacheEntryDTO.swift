import Foundation
import GRDB

// MARK: - CacheEntryType + DatabaseValueConvertible

extension CacheEntryType: DatabaseValueConvertible {}

// MARK: - DBCacheEntryDTO

struct DBCacheEntryDTO: Codable, FetchableRecord, PersistableRecord {
	var key: String
	var type: CacheEntryType
	var url: URL
	var lastAccessedAt: Date
	var size: Int

	static let databaseTableName = "cacheEntries"

	enum Columns {
		static let key = Column(CodingKeys.key)
		static let type = Column(CodingKeys.type)
		static let url = Column(CodingKeys.url)
		static let lastAccessedAt = Column(CodingKeys.lastAccessedAt)
		static let size = Column(CodingKeys.size)
	}

	init(key: String, type: CacheEntryType, url: URL, lastAccessedAt: Date = Date.now, size: Int) {
		self.key = key
		self.type = type
		self.url = url
		self.lastAccessedAt = lastAccessedAt
		self.size = size
	}

	init(from entry: CacheEntry) {
		key = entry.key
		type = entry.type
		url = entry.url
		lastAccessedAt = entry.lastAccessedAt
		size = entry.size
	}

	func toCacheEntry() -> CacheEntry {
		CacheEntry(key: key, type: type, url: url, lastAccessedAt: lastAccessedAt, size: size)
	}
}
