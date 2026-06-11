@testable import Offliner
import XCTest

final class CollectionDownloadTests: OfflinerTestCase {
	// MARK: - Album Download Tests

	func testDownloadAlbumDoesNotCreateDownloadObject() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()

		let downloads = await offliner.currentDownloads
		XCTAssertEqual(downloads.count, 0)
	}

	func testDownloadAlbumStoresInLocalDatabase() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = await offliner.getOfflineCollection(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		).latest()
		XCTAssertNotNil(storedCollection)

		XCTAssertEqual(storedCollection?.catalogMetadata.id, "album-123")
		if case .album = storedCollection?.catalogMetadata {
		} else {
			XCTFail("Expected album metadata")
		}
	}

	func testOfflineCollectionDownloadStateEmitsDownloadedSnapshotImmediately() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()

		let state = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		).first()

		XCTAssertEqual(state, .downloaded)
	}

	func testOfflineCollectionDownloadStateUsesInMemoryCollectionTask() async throws {
		let backend = StubOfflineApiClient()
		let artworkDownloader = SuspendingArtworkDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: artworkDownloader,
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await backend.addItem(type: .album, id: "album-123")
		let runTask = Task { await offliner.run() }
		await artworkDownloader.waitUntilStarted()

		let state = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		).first()

		XCTAssertEqual(state, .downloading)

		await artworkDownloader.complete()
		await runTask.value
	}

	func testOfflineCollectionDownloadStateUsesCurrentRelatedDownloads() async throws {
		let backend = StubOfflineApiClient()
		let mediaDownloader = SuspendingMediaDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: mediaDownloader
		)

		try await backend.addItem(type: .track, id: "track-123")

		let downloads = offliner.newDownloads
		await offliner.run()

		var downloadIterator = downloads.makeAsyncIterator()
		_ = await downloadIterator.next()
		await mediaDownloader.waitUntilStarted()

		let state = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("stub-album")
		).first()

		XCTAssertEqual(state, .downloading)

		await mediaDownloader.complete()
		await backend.waitForTasksToComplete()
	}

	func testOfflineCollectionDownloadStateTreatsSdkRemovalAsNotDownloadedImmediately() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()

		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-123"))

		let state = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		).first()

		XCTAssertEqual(state, .notDownloaded)
		await backend.waitForTasksToComplete()
	}

	func testOfflineCollectionDownloadStateEmitsNotDownloadedImmediatelyWhenNotStoredAndNotPending() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let state = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		).first()

		XCTAssertEqual(state, .notDownloaded)
	}

	func testRedownloadAlbumDeletesOldArtworkAndStoresNewOne() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()

		let firstCollectionOptional = await offliner.getOfflineCollection(collectionType: .albums, resourceId: .identifier("album-123")).latest()
		let firstCollection = try XCTUnwrap(firstCollectionOptional)
		let firstArtworkURL = try XCTUnwrap(firstCollection.artworkURL)
		XCTAssertTrue(FileManager.default.fileExists(atPath: firstArtworkURL.path))

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()

		let secondCollectionOptional = await offliner.getOfflineCollection(collectionType: .albums, resourceId: .identifier("album-123")).latest()
		let secondCollection = try XCTUnwrap(secondCollectionOptional)
		let secondArtworkURL = try XCTUnwrap(secondCollection.artworkURL)

		XCTAssertFalse(FileManager.default.fileExists(atPath: firstArtworkURL.path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: secondArtworkURL.path))
		XCTAssertNotEqual(firstArtworkURL, secondArtworkURL)
	}

	func testDownloadAlbumFailsWhenArtworkDownloadFails() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: FailingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = await offliner.getOfflineCollection(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		).latest()
		XCTAssertNil(storedCollection)
	}

	// MARK: - Playlist Download Tests

	func testDownloadPlaylistStoresInLocalDatabase() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .playlists, resourceId: .identifier("playlist-456"))
		await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = await offliner.getOfflineCollection(
			collectionType: .playlists,
			resourceId: .identifier("playlist-456")
		).latest()
		XCTAssertNotNil(storedCollection)

		XCTAssertEqual(storedCollection?.catalogMetadata.id, "playlist-456")
		if case .playlist = storedCollection?.catalogMetadata {
		} else {
			XCTFail("Expected playlist metadata")
		}
	}

	func testDownloadPlaylistFailsWhenArtworkDownloadFails() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: FailingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .playlists, resourceId: .identifier("playlist-456"))
		await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = await offliner.getOfflineCollection(
			collectionType: .playlists,
			resourceId: .identifier("playlist-456")
		).latest()
		XCTAssertNil(storedCollection)
	}
}
