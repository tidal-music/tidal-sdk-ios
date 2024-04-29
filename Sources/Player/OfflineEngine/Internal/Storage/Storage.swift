import Foundation

// MARK: - Storage

class Storage {
	private let encoder: JSONEncoder
	private let decoder: JSONDecoder
	private let cache: Cache

	init() {
		encoder = JSONEncoder()
		decoder = JSONDecoder()
		cache = Cache(memoryCapacity: 0, diskCapacity: 10 * 1024 * 1024, keyPrefix: "offline")
	}

	func get(mediaProduct: MediaProduct) -> StorageItem? {
		guard let key = try? serialize(mediaProduct),
		      let data = cache.get(key: key)
		else {
			return nil
		}

		return try? deserialize(data)
	}

	func store(storageItem: StorageItem) {
		guard let key = try? serialize(MediaProduct(productType: storageItem.productType, productId: storageItem.productId)),
		      let data = try? serialize(storageItem)
		else {
			return
		}

		cache.set(key: key, data: data)
	}

	func delete(mediaProduct: MediaProduct) {
		guard let key = try? serialize(mediaProduct) else {
			return
		}

		cache.delete(key: key)
	}

	func clear() {
		cache.clear()
	}
}

private extension Storage {
	func serialize(_ mediaProduct: MediaProduct) throws -> Data {
		try encoder.encode(MediaProduct(productType: mediaProduct.productType, productId: mediaProduct.productId))
	}

	func serialize(_ storageItem: StorageItem) throws -> Data {
		try encoder.encode(storageItem)
	}

	func deserialize(_ data: Data) throws -> StorageItem {
		try decoder.decode(StorageItem.self, from: data)
	}
}
