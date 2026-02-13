@testable import Offliner
import TidalAPI
import XCTest

final class RemoveTests: OfflinerTestCase {
	// MARK: - Remove Media Item

	func testRemoveTrackDeletesFromLocalDatabase() async throws {
		let backend = StubBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")
		try await downloadAndWaitForCompletion(offliner)

		let storedItem = try offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		XCTAssertNotNil(storedItem)

		try await offliner.remove(mediaType: .tracks, resourceId: "track-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let removedItem = try offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		XCTAssertNil(removedItem)
	}

	func testRemoveTrackDeletesFiles() async throws {
		let backend = StubBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")
		try await downloadAndWaitForCompletion(offliner)

		let storedItem = try XCTUnwrap(
			offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		)
		let mediaURL = storedItem.mediaURL
		let artworkURL = try XCTUnwrap(storedItem.artworkURL)
		XCTAssertTrue(FileManager.default.fileExists(atPath: mediaURL.path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: artworkURL.path))

		try await offliner.remove(mediaType: .tracks, resourceId: "track-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		XCTAssertFalse(FileManager.default.fileExists(atPath: mediaURL.path))
		XCTAssertFalse(FileManager.default.fileExists(atPath: artworkURL.path))
	}

	func testRemoveVideoDeletesFromLocalDatabase() async throws {
		let backend = StubBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .videos, resourceId: "video-456")
		try await downloadAndWaitForCompletion(offliner)

		let storedItem = try offliner.getOfflineMediaItem(mediaType: .videos, resourceId: "video-456")
		XCTAssertNotNil(storedItem)

		try await offliner.remove(mediaType: .videos, resourceId: "video-456")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let removedItem = try offliner.getOfflineMediaItem(mediaType: .videos, resourceId: "video-456")
		XCTAssertNil(removedItem)
	}

	// MARK: - Remove Collection

	func testRemoveAlbumDeletesFromLocalDatabase() async throws {
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

		try await offliner.remove(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let removedCollection = try offliner.getOfflineCollection(
			collectionType: .albums,
			resourceId: "album-123"
		)
		XCTAssertNil(removedCollection)
	}

	func testRemoveAlbumDeletesArtworkFile() async throws {
		let backend = StubBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try XCTUnwrap(
			offliner.getOfflineCollection(collectionType: .albums, resourceId: "album-123")
		)
		let artworkURL = try XCTUnwrap(storedCollection.artworkURL)
		XCTAssertTrue(FileManager.default.fileExists(atPath: artworkURL.path))

		try await offliner.remove(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		XCTAssertFalse(FileManager.default.fileExists(atPath: artworkURL.path))
	}

	func testRemoveNonExistentItemDoesNotThrow() async throws {
		let backend = StubBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.remove(mediaType: .tracks, resourceId: "nonexistent")
		try await offliner.run()
		await backend.waitForTasksToComplete()
	}
}
