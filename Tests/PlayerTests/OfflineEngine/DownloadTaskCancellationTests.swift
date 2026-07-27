@testable import Player
import Testing

struct DownloadTaskCancellationTests {
	// Note: Direct DownloadTask instantiation tests are not possible on iOS Simulator
	// because DownloadTask creates AVContentKeySession which requires FairPlay support.
	// Cancellation behavior is verified through integration with Downloader.

	@Test
	func testDownloaderCancelReturnsFalseForNonExistentDownload() {
		// Given: A downloader with no active downloads
		let downloader = Downloader.mock()
		let mediaProduct = MediaProduct(productType: .TRACK, productId: "999")

		// When: Cancelling a non-existent download
		let result = downloader.cancel(mediaProduct: mediaProduct)

		// Then: Should return false
		#expect(!result, "Cancelling non-existent download should return false")
	}
}
