@testable import Offliner
import XCTest

final class UserCollectionTracksTests: OfflinerTestCase {
	// MARK: - Download

	func testDownloadUserCollectionTracksStoresInLocalDatabase() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.downloadUserCollectionTracks()
		await offliner.run()
		await backend.waitForTasksToComplete()

		XCTAssertEqual(backend.addedItems.count, 1)
		XCTAssertEqual(backend.addedItems.first?.type, .userCollectionTracks)
		XCTAssertEqual(backend.addedItems.first?.id, "me")
	}

	func testDownloadUserCollectionTracksDoesNotCreateDownloadObject() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.downloadUserCollectionTracks()
		await offliner.run()

		let downloads = await offliner.currentDownloads
		XCTAssertEqual(downloads.count, 0)
	}

	// MARK: - Remove

	func testRemoveUserCollectionTracks() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.removeUserCollectionTracks()

		XCTAssertEqual(backend.removedItems.count, 1)
		XCTAssertEqual(backend.removedItems.first?.type, .userCollectionTracks)
		XCTAssertEqual(backend.removedItems.first?.id, "me")
	}
}
