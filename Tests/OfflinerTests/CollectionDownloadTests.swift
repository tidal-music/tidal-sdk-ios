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

	func testOfflineCollectionDownloadStateReportsDownloadedWhenStoredAndNotPending() async throws {
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

	func testOfflineCollectionDownloadStateReportsDownloadingWhenStoredButPending() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()
		backend.pendingCollection = .mock(
			catalogMetadata: .album(.mock(id: "album-123")),
			state: .pending
		)

		let state = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-123")
		).first()

		XCTAssertEqual(state, .downloading)
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
