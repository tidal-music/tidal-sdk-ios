import Foundation

public class Download: Equatable {
	public enum State {
		case pending
		case inProgress
		case failed
		case completed
	}

	public var metadata: OfflineMediaItem.Metadata { task.metadata }
	public private(set) var state: State
	public private(set) var progress: Double = 0

	let task: StoreItemTask

	private var continuation: AsyncStream<Update>.Continuation?
	public lazy var updates: AsyncStream<Update> = {
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
		continuation?.yield(.stateChanged(newState))
	}

	internal func updateProgress(_ newProgress: Double) {
		progress = newProgress
		continuation?.yield(.progress(newProgress))
	}

	public static func == (lhs: Download, rhs: Download) -> Bool {
		lhs.task.id == rhs.task.id
	}
}

public extension Download {
	enum Update {
		case stateChanged(State)
		case progress(Double)
	}
}
