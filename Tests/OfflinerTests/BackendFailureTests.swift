@testable import Offliner
import XCTest

final class BackendFailureTests: OfflinerTestCase {
	func testDownloadTrackAbortsWhenUpdateTaskToInProgressFails() async throws {
		let backend = FailOnUpdateToInProgressBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			XCTAssertEqual(download.state, .pending)
			break
		}

		try await runTask

		let storedItem = try offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		XCTAssertNil(storedItem)
	}

	func testDownloadTrackFailsWhenUpdateTaskToCompletedFails() async throws {
		let backend = FailOnUpdateToCompletedBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			await assertEventually(events) { event in
				if case .state(.failed) = event { return true }
				return false
			}
			break
		}

		try await runTask

		let storedItem = try offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		XCTAssertNotNil(storedItem)
	}

	func testDownloadTrackFailsWhenAddItemFails() async throws {
		let offliner = createOffliner(
			backendClient: FailingBackendClient(),
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
			backendClient: FailingBackendClient(),
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

	func testGetTasksFailurePropagates() async throws {
		let backend = FailOnGetTasksBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		do {
			try await offliner.run()
			XCTFail("Expected run to throw when getTasks fails")
		} catch {
			// Expected - getTasks failure propagates from run()
		}
	}
}
