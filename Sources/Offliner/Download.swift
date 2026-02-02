import Foundation

public class Download: Equatable {
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
	public private(set) var state: State
	public private(set) var progress: Double = 0

	let task: StoreItemTask

	private var continuation: AsyncStream<Event>.Continuation?
	public lazy var events: AsyncStream<Event> = {
		AsyncStream { continuation in
			self.continuation = continuation
		}
	}()

	internal init(task: StoreItemTask, state: State) {
		self.task = task
		self.state = state
	}

	internal func updateState(_ newState: State) {
		state = newState
		continuation?.yield(.state(newState))
	}

	internal func updateProgress(_ newProgress: Double) {
		progress = newProgress
		continuation?.yield(.progress(newProgress))
	}

	public static func == (lhs: Download, rhs: Download) -> Bool {
		lhs.task.id == rhs.task.id
	}
}
