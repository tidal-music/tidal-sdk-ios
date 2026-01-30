import Foundation
import TidalAPI

public class DownloadTask: Equatable {
	public let id: String
	public let type: DownloadTaskType
	public private(set) var state: OfflineTaskState
	public private(set) var progress: Double = 0

	let resourceType: String
	let resourceId: String
	let volume: Int?
	let index: Int?
	let collectionId: String?

	private var continuation: AsyncStream<DownloadTaskUpdate>.Continuation?
	public lazy var updates: AsyncStream<DownloadTaskUpdate> = {
		AsyncStream { continuation in
			self.continuation = continuation
		}
	}()

	internal init(from task: OfflineTask) {
		id = task.taskId
		type = .from(offlineTask: task)
		state = .pending
		resourceType = task.type
		resourceId = task.resourceId
		volume = task.volume
		index = task.index
		collectionId = task.collectionId
	}

	internal func updateState(_ newState: OfflineTaskState) {
		state = newState
		continuation?.yield(.stateChanged(newState))
	}

	internal func updateProgress(_ newProgress: Double) {
		progress = newProgress
		continuation?.yield(.progress(newProgress))
	}

	public static func == (lhs: DownloadTask, rhs: DownloadTask) -> Bool {
		lhs.id == rhs.id
	}
}

public enum DownloadTaskUpdate {
	case stateChanged(OfflineTaskState)
	case progress(Double)
}

public enum DownloadTaskType {
	case storeItem
	case storeCollection
	case removeItem
	case removeCollection
	
	static func from(offlineTask: OfflineTask) -> DownloadTaskType {
		switch offlineTask.action {
		case .storeItem:
			return .storeItem
		case .storeCollection:
			return .storeCollection
		case .removeItem:
			return .removeItem
		case .removeCollection:
			return .removeCollection
		}
	}
}
