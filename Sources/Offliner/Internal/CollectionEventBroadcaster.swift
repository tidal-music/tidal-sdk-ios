import Foundation

/// Delivers every ``OfflineCollectionEvent`` to every open stream.
final class CollectionEventBroadcaster: @unchecked Sendable {
	private let lock = NSLock()
	private var continuations: [UUID: AsyncStream<OfflineCollectionEvent>.Continuation] = [:]

	func stream() -> AsyncStream<OfflineCollectionEvent> {
		let (stream, continuation) = AsyncStream<OfflineCollectionEvent>.makeStream()
		let id = UUID()
		continuation.onTermination = { [weak self] _ in
			guard let self else {
				return
			}
			lock.withLock { _ = self.continuations.removeValue(forKey: id) }
		}
		lock.withLock { continuations[id] = continuation }
		return stream
	}

	func emit(_ event: OfflineCollectionEvent) {
		let continuations = lock.withLock { Array(self.continuations.values) }
		for continuation in continuations {
			continuation.yield(event)
		}
	}
}
