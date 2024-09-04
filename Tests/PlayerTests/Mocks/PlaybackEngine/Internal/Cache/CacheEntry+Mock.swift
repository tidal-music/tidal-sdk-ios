import Foundation
@testable import Player

extension CacheEntry {
	static func mock(
		key: String,
		type: CacheEntryType = CacheEntryType.hls,
		url: URL,
		lastAccessedAt: Date,
		size: Int
	) -> CacheEntry {
		CacheEntry(
			key: key,
			type: type,
			url: url,
			lastAccessedAt: lastAccessedAt,
			size: size
		)
	}
}
