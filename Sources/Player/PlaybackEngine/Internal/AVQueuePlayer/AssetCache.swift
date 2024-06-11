import Foundation

// MARK: - AssetCacheState

public struct AssetCacheState {
	public enum AssetCacheStatus: Equatable {
		case notCached
		case cached(cachedURL: URL)
	}

	public let key: String
	public let status: AssetCacheStatus

	public init(key: String, status: AssetCacheState.AssetCacheStatus) {
		self.key = key
		self.status = status
	}
}

// MARK: - AssetCache

public final class AssetCache {
	private var userDefaults: UserDefaultsClient

	public init(userDefaults: UserDefaultsClient = UserDefaultsClient.live()) {
		self.userDefaults = userDefaults
	}

	public func get(_ key: String) -> AssetCacheState {
		var isBookmarkStale = false
		let url = userDefaults.dataForKey(key)
			.flatMap { try? URL(resolvingBookmarkData: $0, bookmarkDataIsStale: &isBookmarkStale) }

		guard let url else {
			return AssetCacheState(key: key, status: .notCached)
		}

		if isBookmarkStale {
			set(url, with: key)
		}

		return AssetCacheState(key: key, status: .cached(cachedURL: url))
	}

	public func set(_ url: URL, with cacheKey: String) {
		if let data = try? url.bookmarkData() {
			userDefaults.setDataForKey(data, cacheKey)
		}
	}

	public func delete(_ key: String) {
		let state = get(key)
		userDefaults.removeObjectForKey(key)
		if case let .cached(url) = state.status {
			deleteFile(at: url)
		}
	}
}

extension AssetCache {
	func deleteFile(at url: URL) {
		let fileManager = PlayerWorld.fileManagerClient
		try? fileManager.removeItem(at: url)
	}
}
