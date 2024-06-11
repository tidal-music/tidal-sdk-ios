import Foundation

// MARK: - AssetCacheLegacy

final class AssetCacheLegacy {
	private var userDefaults: UserDefaultsClient

	init(userDefaults: UserDefaultsClient = UserDefaultsClient.live()) {
		self.userDefaults = userDefaults
	}

	func get(_ key: String) -> URL? {
		var bookmarkIsStale = false
		let url = userDefaults.dataForKey(key)
			.flatMap { try? URL(resolvingBookmarkData: $0, bookmarkDataIsStale: &bookmarkIsStale) }

		if let url, bookmarkIsStale {
			set(url, with: key)
		}

		return url
	}

	func set(_ url: URL, with cacheKey: String) {
		if let data = try? url.bookmarkData() {
			userDefaults.setDataForKey(data, cacheKey)
		}
	}

	func delete(_ key: String) {
		delete(get(key), and: key)
	}
}

private extension AssetCacheLegacy {
	func delete(_ url: URL?, and key: String) {
		guard let url else {
			return
		}

		do {
			let fileManager = PlayerWorld.fileManagerClient
			try fileManager.removeItem(at: url)
			userDefaults.removeObjectForKey(key)
		} catch {
			print("Failed to remove item: \(error)")
		}
	}
}
