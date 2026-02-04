import Foundation

public final class Download {
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

	public var metadata: OfflineMediaItem.Metadata { task.metadata }
	public let events: AsyncStream<Event>

	let task: StoreItemTask
	private let continuation: AsyncStream<Event>.Continuation

	internal init(task: StoreItemTask) {
		self.task = task

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
