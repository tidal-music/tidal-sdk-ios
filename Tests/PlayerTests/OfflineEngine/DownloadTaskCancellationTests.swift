@testable import Player
import XCTest

final class DownloadTaskCancellationTests: XCTestCase {
	// Note: Direct DownloadTask instantiation tests are not possible on iOS Simulator
	// because DownloadTask creates AVContentKeySession which requires FairPlay support.
	// Cancellation behavior is verified through integration with Downloader.

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
