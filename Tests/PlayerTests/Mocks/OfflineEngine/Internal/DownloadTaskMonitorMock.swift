import Foundation
@testable import Player

final class DownloadTaskMonitorMock: DownloadTaskMonitor {
	private(set) var completedCalls = 0
	private(set) var failedCalls = 0
	private(set) var progressCalls = 0
	private(set) var startedCalls = 0
	private(set) var emittedEvents: [any StreamingMetricsEvent] = []

	func emit(event: any StreamingMetricsEvent) {
		emittedEvents.append(event)
	}

	func started(downloadTask: DownloadTask) {
		startedCalls += 1
	}

	func progress(downloadTask: DownloadTask, progress: Double) {
		progressCalls += 1
	}

	func completed(downloadTask: DownloadTask, offlineEntry: OfflineEntry) {
		completedCalls += 1
	}

	func failed(downloadTask: DownloadTask, with error: Error) {
		failedCalls += 1
	}
}
