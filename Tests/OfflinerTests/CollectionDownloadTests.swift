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

	func testOfflineCollectionDownloadStateEmitsHydratedDownloadedStateBeforePollingBackend() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()
		try await offliner.hydrateOfflineCollectionDownloadStateCache()

		let state = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		).first()

		XCTAssertEqual(state, .downloaded)
		XCTAssertEqual(backend.getCollectionTaskActivityCallCount, 0)
		XCTAssertEqual(
			offliner.getCachedOfflineCollectionDownloadState(
				collectionType: .albums,
				resourceId: .identifier("album-123")
			),
			.downloaded
		)
	}

	func testDownloadCollectionSeedsCachedDownloadingState() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))

		XCTAssertEqual(
			offliner.getCachedOfflineCollectionDownloadState(
				collectionType: .albums,
				resourceId: .identifier("album-123")
			),
			.downloading
		)
	}

	func testHydrateOfflineCollectionDownloadStateCacheMarksUnknownCollectionsNotDownloaded() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		XCTAssertNil(offliner.getCachedOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		))

		try await offliner.hydrateOfflineCollectionDownloadStateCache()

		XCTAssertEqual(
			offliner.getCachedOfflineCollectionDownloadState(
				collectionType: .albums,
				resourceId: .identifier("album-123")
			),
			.notDownloaded
		)
	}

	func testHydrateOfflineCollectionDownloadStateCacheStoresActiveDownloadTask() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await backend.addItem(type: .album, id: "album-123")
		try await offliner.hydrateOfflineCollectionDownloadStateCache()

		XCTAssertEqual(
			offliner.getCachedOfflineCollectionDownloadState(
				collectionType: .albums,
				resourceId: .identifier("album-123")
			),
			.downloading
		)
	}

	func testHydrateOfflineCollectionDownloadStateCacheStoresActiveRemovalAsNotDownloaded() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()
		try await backend.removeItem(type: .album, id: "album-123")

		try await offliner.hydrateOfflineCollectionDownloadStateCache()

		XCTAssertEqual(
			offliner.getCachedOfflineCollectionDownloadState(
				collectionType: .albums,
				resourceId: .identifier("album-123")
			),
			.notDownloaded
		)
	}

	func testHydrateOfflineCollectionDownloadStateCachePreservesSdkRemovalInvalidation() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()
		backend.enqueueRemoveTasks = false

		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-123"))
		try await offliner.hydrateOfflineCollectionDownloadStateCache()

		XCTAssertEqual(
			offliner.getCachedOfflineCollectionDownloadState(
				collectionType: .albums,
				resourceId: .identifier("album-123")
			),
			.notDownloaded
		)
	}

	func testOfflineCollectionDownloadStateEmitsDownloadingImmediatelyWhenStoreTaskIsActive() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()
		backend.collectionTaskActivityResponses = [.storing]

		let state = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		).first()

		XCTAssertEqual(state, .downloading)
		XCTAssertEqual(backend.getCollectionTaskActivityCallCount, 1)
	}

	func testOfflineCollectionDownloadStateEmitsNotDownloadedImmediatelyWhenRemoveStarts() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()
		_ = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		).first()

		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-123"))

		XCTAssertEqual(
			offliner.getCachedOfflineCollectionDownloadState(
				collectionType: .albums,
				resourceId: .identifier("album-123")
			),
			.notDownloaded
		)

		let state = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		).first()

		XCTAssertEqual(state, .notDownloaded)
		XCTAssertEqual(backend.getCollectionTaskActivityCallCount, 1)
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
		XCTAssertEqual(backend.getCollectionTaskActivityCallCount, 1)
	}

	func testOfflineCollectionDownloadStateRequiresStableDownloadedObservationAfterInitialEmission() async throws {
		let backend = StubOfflineApiClient()
		backend.collectionTaskActivityResponses = [
			.storing,
			.none,
			.storing,
			.none,
			.none,
		]
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader(),
			collectionDownloadStatePollInterval: 1_000_000
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()

		let states = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		).first(2)

		XCTAssertEqual(states, [.downloading, .downloaded])
		XCTAssertGreaterThanOrEqual(backend.getCollectionTaskActivityCallCount, 5)
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
