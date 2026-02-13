@testable import Offliner
import XCTest

final class MediaItemDownloadTests: OfflinerTestCase {
	// MARK: - Track Download Tests

	func testDownloadTrackCreatesDownload() async throws {
		let offliner = createOffliner(
			backendClient: StubBackendClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		var downloadCount = 0
		for await _ in downloads {
			downloadCount += 1
			break
		}

		_ = try await runTask
		XCTAssertEqual(downloadCount, 1)
	}

	func testDownloadTrackCompletesSuccessfully() async throws {
		let offliner = createOffliner(
			backendClient: StubBackendClient(),
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

		try await runTask
	}

	func testDownloadTrackStoresInLocalDatabase() async throws {
		let offliner = createOffliner(
			backendClient: StubBackendClient(),
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

		try await runTask

		let storedItem = try offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		XCTAssertNotNil(storedItem)
		XCTAssertEqual(storedItem?.id, "track-123")

		if case .track(let metadata) = storedItem?.metadata {
			XCTAssertEqual(metadata.track.id, "track-123")
		} else {
			XCTFail("Expected track metadata")
		}
	}

	func testRedownloadTrackDeletesOldFilesAndStoresNewOnes() async throws {
		let offliner = createOffliner(
			backendClient: StubBackendClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")
		try await downloadAndWaitForCompletion(offliner)

		let firstItem = try XCTUnwrap(
			offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		)
		let firstMediaURL = firstItem.mediaURL
		let firstArtworkURL = try XCTUnwrap(firstItem.artworkURL)
		XCTAssertTrue(FileManager.default.fileExists(atPath: firstMediaURL.path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: firstArtworkURL.path))

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")
		try await downloadAndWaitForCompletion(offliner)

		let secondItem = try XCTUnwrap(
			offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		)
		let secondMediaURL = secondItem.mediaURL
		let secondArtworkURL = try XCTUnwrap(secondItem.artworkURL)

		XCTAssertFalse(FileManager.default.fileExists(atPath: firstMediaURL.path))
		XCTAssertFalse(FileManager.default.fileExists(atPath: firstArtworkURL.path))

		XCTAssertTrue(FileManager.default.fileExists(atPath: secondMediaURL.path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: secondArtworkURL.path))

		XCTAssertNotEqual(firstMediaURL, secondMediaURL)
		XCTAssertNotEqual(firstArtworkURL, secondArtworkURL)
	}

	func testDownloadTrackFailsWhenMediaDownloadFails() async throws {
		let offliner = createOffliner(
			backendClient: StubBackendClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: FailingMediaDownloader()
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
	}

	func testFailedDownloadDoesNotStoreInLocalDatabase() async throws {
		let offliner = createOffliner(
			backendClient: StubBackendClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: FailingMediaDownloader()
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
		XCTAssertNil(storedItem)
	}

	func testDownloadMultipleTracksStoresAllInLocalDatabase() async throws {
		let offliner = createOffliner(
			backendClient: StubBackendClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: "track-1")
		try await offliner.download(mediaType: .tracks, resourceId: "track-2")
		try await offliner.download(mediaType: .tracks, resourceId: "track-3")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		var downloadsList: [Download] = []
		for await download in downloads {
			downloadsList.append(download)
			if downloadsList.count == 3 { break }
		}

		await withTaskGroup(of: Void.self) { group in
			for download in downloadsList {
				let events = download.events
				group.addTask {
					for await event in events {
						if case .state(.completed) = event { break }
						if case .state(.failed) = event { break }
					}
				}
			}
		}

		try await runTask

		let storedItems = try offliner.getOfflineMediaItems(mediaType: .tracks)
		XCTAssertEqual(storedItems.count, 3)

		let resourceIds = storedItems.compactMap { item -> String? in
			if case .track(let metadata) = item.metadata {
				return metadata.track.id
			}
			return nil
		}
		XCTAssertTrue(resourceIds.contains("track-1"))
		XCTAssertTrue(resourceIds.contains("track-2"))
		XCTAssertTrue(resourceIds.contains("track-3"))
	}

	func testDownloadTrackReportsProgress() async throws {
		let media = SucceedingMediaDownloader()
		media.progressValues = [0.25, 0.5, 0.75]

		let offliner = createOffliner(
			backendClient: StubBackendClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			var progressValues: [Double] = []
			for await event in events {
				if case .progress(let value) = event {
					progressValues.append(value)
				}
				if case .state(.completed) = event {
					break
				}
			}
			XCTAssertEqual(progressValues, [0.25, 0.5, 0.75])
			break
		}

		try await runTask
	}

	func testDownloadTrackFailsWhenArtworkDownloadFails() async throws {
		let offliner = createOffliner(
			backendClient: StubBackendClient(),
			artworkDownloader: FailingArtworkDownloader(),
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
	}

	// MARK: - Video Download Tests

	func testDownloadVideoStoresInLocalDatabase() async throws {
		let offliner = createOffliner(
			backendClient: StubBackendClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .videos, resourceId: "video-456")

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

		try await runTask

		let storedItem = try offliner.getOfflineMediaItem(mediaType: .videos, resourceId: "video-456")
		XCTAssertNotNil(storedItem)

		if case .video(let metadata) = storedItem?.metadata {
			XCTAssertEqual(metadata.video.id, "video-456")
		} else {
			XCTFail("Expected video metadata")
		}
	}

}
