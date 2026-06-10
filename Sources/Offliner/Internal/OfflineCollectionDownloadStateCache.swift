import Foundation

final class OfflineCollectionDownloadStateCache {
	private struct Key: Hashable {
		let collectionType: OfflineCollectionType
		let resourceId: String
	}

	private let lock = NSLock()
	private var states: [Key: OfflineCollectionDownloadState] = [:]

	func state(collectionType: OfflineCollectionType, resourceId: ResourceId) -> OfflineCollectionDownloadState? {
		lock.lock()
		defer { lock.unlock() }
		return states[Key(collectionType: collectionType, resourceId: resourceId.stringValue)]
	}

	func setState(
		_ state: OfflineCollectionDownloadState,
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) {
		lock.lock()
		defer { lock.unlock() }
		states[Key(collectionType: collectionType, resourceId: resourceId.stringValue)] = state
	}
}
