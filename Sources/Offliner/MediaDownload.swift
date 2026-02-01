import Foundation

public class MediaDownload: Equatable {
	public var item: ItemMetadata { task.item }
	public private(set) var state: OfflineTaskState
	public private(set) var progress: Double = 0

	let task: StoreItemTask

	private var continuation: AsyncStream<MediaDownloadUpdate>.Continuation?
	public lazy var updates: AsyncStream<MediaDownloadUpdate> = {
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

	public static func == (lhs: MediaDownload, rhs: MediaDownload) -> Bool {
		lhs.task.id == rhs.task.id
	}
}

public enum MediaDownloadUpdate {
	case stateChanged(OfflineTaskState)
	case progress(Double)
}
