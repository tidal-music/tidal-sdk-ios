@testable import Player
import XCTest

final class DownloadTaskCancellationTests: XCTestCase {
	func testCancelExecutesSuccessfully() {
		// Given: A download task
		let mediaProduct = MediaProduct(productType: .TRACK, productId: "123")
		let monitor = DownloadTaskMonitorMock()
		let downloadTask = DownloadTask(
			mediaProduct: mediaProduct,
			networkType: .WIFI,
			outputDevice: nil,
			sessionType: .DOWNLOAD,
			monitor: monitor
		)

		// When: Cancel is called
		downloadTask.cancel()

		// Then: Cancel should not trigger monitor callbacks
		XCTAssertEqual(monitor.failedCalls, 0, "Cancel should not call failed callback")
		XCTAssertEqual(monitor.completedCalls, 0, "Cancel should not call completed callback")
	}

	func testCancelIsIdempotent() {
		// Given: A download task
		let mediaProduct = MediaProduct(productType: .TRACK, productId: "123")
		let monitor = DownloadTaskMonitorMock()
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

		// Then: Multiple cancels should not cause issues or additional callbacks
		XCTAssertEqual(monitor.failedCalls, 0)
		XCTAssertEqual(monitor.completedCalls, 0)
	}

	func testCancelPreventsCompletion() {
		// Given: A download task that has started downloading
		let mediaProduct = MediaProduct(productType: .TRACK, productId: "456")
		let monitor = DownloadTaskMonitorMock()
		let downloadTask = DownloadTask(
			mediaProduct: mediaProduct,
			networkType: .WIFI,
			outputDevice: nil,
			sessionType: .DOWNLOAD,
			monitor: monitor
		)

		// Simulate download started
		let mockURL = URL(fileURLWithPath: "/tmp/mock-download")
		downloadTask.setMediaUrl(mockURL)

		// When: Cancel is called before finalization completes
		downloadTask.cancel()

		// Then: Completion callback should not be invoked
		XCTAssertEqual(monitor.completedCalls, 0, "Cancelled download should not complete")
		XCTAssertEqual(monitor.failedCalls, 0, "Cancelled download should not fail")
	}

	func testDownloaderCancelReturnsFalseForNonExistentDownload() {
		// Given: A downloader with no active downloads
		let downloader = Downloader.mock()
		let mediaProduct = MediaProduct(productType: .TRACK, productId: "999")

		// When: Cancelling a non-existent download
		let result = downloader.cancel(mediaProduct: mediaProduct)

		// Then: Should return false
		XCTAssertFalse(result, "Cancelling non-existent download should return false")
	}
}
