@testable import Offliner
import XCTest

final class BackendFailureTests: OfflinerTestCase {
	func testDownloadTrackCompletesLocallyEvenWhenBackendInProgressUpdateFails() async throws {
		let backend = FailOnUpdateToInProgressOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")
		try await downloadAndWaitForCompletion(offliner)

		let storedItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		XCTAssertNotNil(storedItem)
	}

	func testDownloadTrackCompletesLocallyEvenWhenBackendUpdateFails() async throws {
		let backend = FailOnUpdateToCompletedOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			await assertEventually(events) { event in
				if case .state(.completed) = event { return true }
				return false
			}
			break
		}

		await runTask

		let storedItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		XCTAssertNotNil(storedItem)
	}

	func testDownloadTrackFailsWhenAddItemFails() async throws {
		let offliner = createOffliner(
			offlineApiClient: FailingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		do {
			try await offliner.download(mediaType: .tracks, resourceId: "track-123")
			XCTFail("Expected download to throw when addItem fails")
		} catch {
			// Expected - addItem failure should propagate
		}

		let downloads = await offliner.currentDownloads
		XCTAssertEqual(downloads.count, 0)
	}

	func testDownloadAlbumFailsWhenAddItemFails() async throws {
		let offliner = createOffliner(
			offlineApiClient: FailingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		do {
			try await offliner.download(collectionType: .albums, resourceId: "album-123")
			XCTFail("Expected download to throw when addItem fails")
		} catch {
			// Expected - addItem failure should propagate
		}
	}

	func testGetTasksFailureDoesNotHaltRun() async throws {
		let backend = FailOnGetTasksOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		await offliner.run()
	}
}
