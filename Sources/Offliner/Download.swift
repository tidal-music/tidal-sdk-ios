import Foundation

public actor Download {
	public enum State {
		case pending
		case inProgress
		case failed
		case completed
	}

	public enum Event {
		case state(State)
		case progress(Double)
	}

	public nonisolated let metadata: OfflineMediaItem.Metadata
	public nonisolated let events: AsyncStream<Event>

	private let continuation: AsyncStream<Event>.Continuation

	internal init(metadata: OfflineMediaItem.Metadata) {
		self.metadata = metadata

		let (stream, continuation) = AsyncStream<Event>.makeStream()
		self.events = stream
		self.continuation = continuation
	}

	internal func updateState(_ newState: State) {
		continuation.yield(.state(newState))

		if newState == .completed || newState == .failed {
			continuation.finish()
		}
	}

	internal func updateProgress(_ newProgress: Double) {
		continuation.yield(.progress(newProgress))
	}
}
