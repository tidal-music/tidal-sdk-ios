import Foundation

public class Download: Equatable {
	public var item: ItemMetadata { task.item }
	public private(set) var state: OfflineTaskState
	public private(set) var progress: Double = 0

	let task: StoreItemTask

	private var continuation: AsyncStream<DownloadUpdate>.Continuation?
	public lazy var updates: AsyncStream<DownloadUpdate> = {
		AsyncStream { continuation in
			self.continuation = continuation
		}
	}()

	internal init(task: StoreItemTask, state: OfflineTaskState) {
		self.task = task
		self.state = state
	}

	internal func updateState(_ newState: OfflineTaskState) {
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

public enum DownloadUpdate {
	case stateChanged(OfflineTaskState)
	case progress(Double)
}
