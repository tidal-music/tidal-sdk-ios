import Foundation
import GRDB

// MARK: - CacheEntryType + DatabaseValueConvertible

extension CacheEntryType: DatabaseValueConvertible {}

// MARK: - URL + DatabaseValueConvertible

extension URL: DatabaseValueConvertible {
	public var databaseValue: DatabaseValue {
		absoluteString.databaseValue
	}

	public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> Self? {
		guard let string = String.fromDatabaseValue(dbValue) else {
			return nil
		}
		return URL(string: string)
	}
}

// MARK: - CacheEntryGRDBEntity

struct CacheEntryGRDBEntity: Codable, FetchableRecord, PersistableRecord {
	var key: String
	var type: CacheEntryType
	var url: URL
	var lastAccessedAt: Date
	var size: Int

	var cacheEntry: CacheEntry {
		CacheEntry(key: key, type: type, url: url, lastAccessedAt: lastAccessedAt, size: size)
	}

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
}
