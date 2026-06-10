import Foundation

final class OfflineCollectionDownloadStateCache {
	private let lock = NSLock()
	private var states: [OfflineCollectionReference: OfflineCollectionDownloadState] = [:]
	private var locallyRemovedCollections: Set<OfflineCollectionReference> = []
	private var hasHydrated = false

	func state(collectionType: OfflineCollectionType, resourceId: ResourceId) -> OfflineCollectionDownloadState? {
		lock.lock()
		defer { lock.unlock() }
		let collection = OfflineCollectionReference(collectionType: collectionType, resourceId: resourceId)
		return states[collection] ?? (hasHydrated ? .notDownloaded : nil)
	}

	func setState(
		_ state: OfflineCollectionDownloadState,
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) {
		lock.lock()
		defer { lock.unlock() }
		let collection = OfflineCollectionReference(collectionType: collectionType, resourceId: resourceId)
		if state != .notDownloaded {
			locallyRemovedCollections.remove(collection)
		}
		states[collection] = state
	}

	func markRemoved(collectionType: OfflineCollectionType, resourceId: ResourceId) {
		lock.lock()
		defer { lock.unlock() }
		let collection = OfflineCollectionReference(collectionType: collectionType, resourceId: resourceId)
		locallyRemovedCollections.insert(collection)
		states[collection] = .notDownloaded
	}

	func replaceStates(_ newStates: [OfflineCollectionReference: OfflineCollectionDownloadState]) {
		lock.lock()
		defer { lock.unlock() }
		states = newStates
		for collection in locallyRemovedCollections {
			states[collection] = .notDownloaded
		}
		hasHydrated = true
	}
}
