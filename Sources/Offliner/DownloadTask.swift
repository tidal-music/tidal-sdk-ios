import Foundation

class DownloadTask: Equatable {
	let id: String
	let offlineTask: OfflineTask

	private(set) var state: OfflineTaskState
	private(set) var progress: Double = 0

	weak var mediaDownload: MediaDownload?

	init(from task: OfflineTask) {
		self.id = task.id
		self.state = .pending
		self.offlineTask = task
	}

	func updateState(_ newState: OfflineTaskState) {
		state = newState
		mediaDownload?.updateState(newState)
	}

	func updateProgress(_ newProgress: Double) {
		progress = newProgress
		mediaDownload?.updateProgress(newProgress)
	}

	static func == (lhs: DownloadTask, rhs: DownloadTask) -> Bool {
		lhs.id == rhs.id
	}
}
