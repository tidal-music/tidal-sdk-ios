import Foundation
import GRDB

// MARK: - CacheEntryType + DatabaseValueConvertible

extension CacheEntryType: DatabaseValueConvertible {}

// MARK: - Date + DatabaseValueConvertible (Graceful Fallback)

extension Date: DatabaseValueConvertible {
	public var databaseValue: DatabaseValue {
		// Use GRDB's default format for new entries
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		return formatter.string(from: self).databaseValue
	}

	public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> Self? {
		guard let string = String.fromDatabaseValue(dbValue) else {
			return nil
		}

		// Try ISO8601 format first (for future use)
		if let date = ISO8601DateFormatter().date(from: string) {
			return date
		}

		// Try GRDB's standard datetime format
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
		dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
		if let date = dateFormatter.date(from: string) {
			return date
		}

		// Graceful fallback: corrupted dates (like year 57803) get replaced with current date
		// This allows the app to recover from buggy entries stored before the fix
		return Date()
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
