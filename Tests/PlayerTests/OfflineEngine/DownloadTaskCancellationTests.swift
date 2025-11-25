@testable import Player
import Foundation
import Testing

@Test("Cancel executes without throwing")
func cancelExecutesSuccessfully() {
	// Given: A download task
	let mediaProduct = MediaProduct(productType: .TRACK, productId: "123")
	let monitor = MockDownloadTaskMonitor()
	let downloadTask = DownloadTask(
		mediaProduct: mediaProduct,
		networkType: .WIFI,
		outputDevice: nil,
		sessionType: .DOWNLOAD,
		monitor: monitor
	)

	// When: Cancel is called
	// This sets the private isCancelled flag to true (line 153 in DownloadTask)
	downloadTask.cancel()

	// Then: Cancel should execute without throwing
	// The isCancelled flag is now set, which will prevent finalize() from calling
	// the completion callback when checked at line 208
	#expect(monitor.failedCalls == 0, "Cancel should not call failed callback")
	#expect(monitor.completedCalls == 0, "Cancel should not call completed callback")
}

@Test("Cancel is idempotent")
func cancelIsIdempotent() {
	// Given: A download task
	let mediaProduct = MediaProduct(productType: .TRACK, productId: "123")
	let monitor = MockDownloadTaskMonitor()
	let downloadTask = DownloadTask(
		mediaProduct: mediaProduct,
		networkType: .WIFI,
		outputDevice: nil,
		sessionType: .DOWNLOAD,
		monitor: monitor
	)

	// When: Cancel is called multiple times
	downloadTask.cancel()
	downloadTask.cancel()
	downloadTask.cancel()

	// Then: Multiple cancels should not cause issues
	// File cleanup errors are logged but don't throw
	#expect(monitor.failedCalls == 0)
	#expect(monitor.completedCalls == 0)
}

// MARK: - Mock DownloadTaskMonitor

private class MockDownloadTaskMonitor: DownloadTaskMonitor {
	var completedCalls = 0
	var failedCalls = 0
	var progressCalls = 0
	var startedCalls = 0
	var emittedEvents: [any StreamingMetricsEvent] = []

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
