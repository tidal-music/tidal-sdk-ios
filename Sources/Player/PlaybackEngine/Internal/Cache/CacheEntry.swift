import Foundation

// MARK: - CacheEntry

public struct CacheEntry: Codable {
	var key: String
	var type: CacheEntryType
	var url: URL?
	var lastAccessedAt: Date
	var size: Int

	init(key: String, type: CacheEntryType, url: URL?, lastAccessedAt: Date = Date.now, size: Int) {
		self.key = key
		self.type = type
		self.url = url
		self.lastAccessedAt = lastAccessedAt
		self.size = size
	}
}

// MARK: Equatable

extension CacheEntry: Equatable {
	public static func == (lhs: CacheEntry, rhs: CacheEntry) -> Bool {
		lhs.key == rhs.key &&
			lhs.type == rhs.type &&
			lhs.url == rhs.url &&
			lhs.lastAccessedAt == rhs.lastAccessedAt &&
			lhs.size == rhs.size
	}
}
