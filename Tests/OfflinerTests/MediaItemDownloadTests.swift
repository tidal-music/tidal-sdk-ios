@testable import Offliner
import GRDB
import XCTest

final class MediaItemDownloadTests: OfflinerTestCase {
	// MARK: - Track Download Tests

	func testDownloadTrackCreatesDownload() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		var downloadCount = 0
		for await _ in downloads {
			downloadCount += 1
			break
		}

		_ = await runTask
		XCTAssertEqual(downloadCount, 1)
	}

	func testDownloadTrackCompletesSuccessfully() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))

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
	}

	func testDownloadTrackStoresInLocalDatabase() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))

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

		let storedItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-123"))
		XCTAssertNotNil(storedItem)
		XCTAssertEqual(storedItem?.catalogMetadata.id, "track-123")

		if case .track = storedItem?.catalogMetadata {
		} else {
			XCTFail("Expected track metadata")
		}
	}

	func testMovedArtworkFileRenewsStoredBookmark() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))
		try await downloadAndWaitForCompletion(offliner)

		let storedItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-123"))
		let artworkURL = try XCTUnwrap(storedItem?.artworkURL)
		let movedURL = artworkURL.deletingLastPathComponent().appendingPathComponent("moved-artwork-\(UUID().uuidString).jpg")
		addTeardownBlock {
			try? FileManager.default.removeItem(at: movedURL)
		}
		try FileManager.default.moveItem(at: artworkURL, to: movedURL)

		let renewedItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-123"))
		let renewedArtworkURL = try XCTUnwrap(renewedItem?.artworkURL)
		XCTAssertEqual(renewedArtworkURL.standardizedFileURL.path, movedURL.standardizedFileURL.path)

		let renewedBookmark = try await lastDatabaseQueue.read { database in
			try Data.fetchOne(
				database,
				sql: "SELECT artwork_bookmark FROM offline_item WHERE resource_type = 'tracks' AND resource_id = 'track-123'"
			)
		}
		let embeddedValues = URL.resourceValues(
			forKeys: [.pathKey, .canonicalPathKey],
			fromBookmarkData: try XCTUnwrap(renewedBookmark)
		)
		let embeddedPath = try XCTUnwrap(embeddedValues?.path ?? embeddedValues?.canonicalPath)
		XCTAssertEqual(URL(fileURLWithPath: embeddedPath).standardizedFileURL.path, movedURL.standardizedFileURL.path)
	}

	func testRepeatedDownloadTrackIsIdempotentAfterCompletion() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))
		try await downloadAndWaitForCompletion(offliner)

		let firstItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-123"))
		let firstItemUnwrapped = try XCTUnwrap(firstItem)
		let firstPlayableItem = await offliner.getOfflinePlaybackAsset(
			mediaType: .tracks,
			resourceId: .identifier("track-123")
		)
		let firstMediaURL = try XCTUnwrap(firstPlayableItem?.mediaURL)
		let firstArtworkURL = try XCTUnwrap(firstItemUnwrapped.artworkURL)
		XCTAssertTrue(FileManager.default.fileExists(atPath: firstMediaURL.path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: firstArtworkURL.path))

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))

		let secondItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-123"))
		let secondItemUnwrapped = try XCTUnwrap(secondItem)
		let secondPlayableItem = await offliner.getOfflinePlaybackAsset(
			mediaType: .tracks,
			resourceId: .identifier("track-123")
		)
		let secondMediaURL = try XCTUnwrap(secondPlayableItem?.mediaURL)
		let secondArtworkURL = try XCTUnwrap(secondItemUnwrapped.artworkURL)

		XCTAssertTrue(FileManager.default.fileExists(atPath: firstMediaURL.path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: firstArtworkURL.path))

		XCTAssertTrue(FileManager.default.fileExists(atPath: secondMediaURL.path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: secondArtworkURL.path))

		XCTAssertEqual(firstMediaURL, secondMediaURL)
		XCTAssertEqual(firstArtworkURL, secondArtworkURL)
		XCTAssertEqual(backend.addedItems.count, 1)
	}

	func testDownloadTrackFailsWhenMediaDownloadFails() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: FailingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))

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

		await runTask
	}

	func testFailedDownloadDoesNotStoreInLocalDatabase() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: FailingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))

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

		await runTask

		let storedItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-123"))
		XCTAssertNil(storedItem)
	}

	func testDownloadMultipleTracksStoresAllInLocalDatabase() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-1"))
		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-2"))
		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-3"))

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

		await runTask

		let storedItems = try await offliner.getOfflineMediaItems(mediaType: .tracks)
		XCTAssertEqual(storedItems.count, 3)

		let resourceIds = storedItems.map(\.catalogMetadata.id)
		XCTAssertTrue(resourceIds.contains("track-1"))
		XCTAssertTrue(resourceIds.contains("track-2"))
		XCTAssertTrue(resourceIds.contains("track-3"))
	}

	func testDownloadTrackReportsProgress() async throws {
		let media = SucceedingMediaDownloader()
		media.progressValues = [0.25, 0.5, 0.75]

		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))

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

		await runTask
	}

	func testDownloadTrackFailsWhenArtworkDownloadFails() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: FailingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))

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

		await runTask
	}

	// MARK: - Video Download Tests

	func testDownloadVideoStoresInLocalDatabase() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .videos, resourceId: .identifier("video-456"))

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

		let storedItem = try await offliner.getOfflineMediaItem(mediaType: .videos, resourceId: .identifier("video-456"))
		XCTAssertNotNil(storedItem)

		XCTAssertEqual(storedItem?.catalogMetadata.id, "video-456")
		if case .video = storedItem?.catalogMetadata {
		} else {
			XCTFail("Expected video metadata")
		}
	}

}
