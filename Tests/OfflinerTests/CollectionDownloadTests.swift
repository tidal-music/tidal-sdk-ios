@testable import Offliner
import XCTest

final class CollectionDownloadTests: OfflinerTestCase {
	// MARK: - Album Download Tests

	func testDownloadAlbumDoesNotCreateDownloadObject() async throws {
		let offliner = createOffliner(
			backendClient: StubBackendClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()

		let downloads = await offliner.currentDownloads
		XCTAssertEqual(downloads.count, 0)
	}

	func testDownloadAlbumStoresInLocalDatabase() async throws {
		let backend = StubBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try offliner.getOfflineCollection(
			collectionType: .albums,
			resourceId: "album-123"
		)
		XCTAssertNotNil(storedCollection)

		XCTAssertEqual(storedCollection?.metadata.id, "album-123")
		if case .album = storedCollection?.metadata {
		} else {
			XCTFail("Expected album metadata")
		}
	}

	func testRedownloadAlbumDeletesOldArtworkAndStoresNewOne() async throws {
		let backend = StubBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let firstCollection = try XCTUnwrap(
			offliner.getOfflineCollection(collectionType: .albums, resourceId: "album-123")
		)
		let firstArtworkURL = try XCTUnwrap(firstCollection.artworkURL)
		XCTAssertTrue(FileManager.default.fileExists(atPath: firstArtworkURL.path))

		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let secondCollection = try XCTUnwrap(
			offliner.getOfflineCollection(collectionType: .albums, resourceId: "album-123")
		)
		let secondArtworkURL = try XCTUnwrap(secondCollection.artworkURL)

		XCTAssertFalse(FileManager.default.fileExists(atPath: firstArtworkURL.path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: secondArtworkURL.path))
		XCTAssertNotEqual(firstArtworkURL, secondArtworkURL)
	}

	func testDownloadAlbumFailsWhenArtworkDownloadFails() async throws {
		let backend = StubBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: FailingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try offliner.getOfflineCollection(
			collectionType: .albums,
			resourceId: "album-123"
		)
		XCTAssertNil(storedCollection)
	}

	// MARK: - Playlist Download Tests

	func testDownloadPlaylistStoresInLocalDatabase() async throws {
		let backend = StubBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .playlists, resourceId: "playlist-456")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try offliner.getOfflineCollection(
			collectionType: .playlists,
			resourceId: "playlist-456"
		)
		XCTAssertNotNil(storedCollection)

		XCTAssertEqual(storedCollection?.metadata.id, "playlist-456")
		if case .playlist = storedCollection?.metadata {
		} else {
			XCTFail("Expected playlist metadata")
		}
	}

	func testDownloadPlaylistFailsWhenArtworkDownloadFails() async throws {
		let backend = StubBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: FailingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .playlists, resourceId: "playlist-456")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try offliner.getOfflineCollection(
			collectionType: .playlists,
			resourceId: "playlist-456"
		)
		XCTAssertNil(storedCollection)
	}
}
