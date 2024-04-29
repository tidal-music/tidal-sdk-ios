import Foundation
@testable import Player

final class StorageMock: Storage {
	override func get(mediaProduct: MediaProduct) -> StorageItem? {
		nil
	}

	override func store(storageItem: StorageItem) {}

	override func delete(mediaProduct: MediaProduct) {}

	override func clear() {}
}
