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

		try await offliner.download(collectionType: .userCollectionTracks, resourceId: "uct-123")
		await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try await offliner.getOfflineCollection(
			collectionType: .userCollectionTracks,
			resourceId: "uct-123"
		)
		XCTAssertNotNil(storedCollection)
		XCTAssertEqual(storedCollection?.catalogMetadata.id, "uct-123")

		if case .userCollectionTracks = storedCollection?.catalogMetadata {
		} else {
			XCTFail("Expected userCollectionTracks metadata")
		}
	}

	func testDownloadUserCollectionTracksDoesNotCreateDownloadObject() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .userCollectionTracks, resourceId: "uct-123")
		await offliner.run()

		let downloads = await offliner.currentDownloads
		XCTAssertEqual(downloads.count, 0)
	}

	func testGetUserCollectionTracksListsAllStored() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .userCollectionTracks, resourceId: "uct-1")
		await offliner.run()
		await backend.waitForTasksToComplete()

		try await offliner.download(collectionType: .userCollectionTracks, resourceId: "uct-2")
		await offliner.run()
		await backend.waitForTasksToComplete()

		let collections = try await offliner.getOfflineCollections(collectionType: .userCollectionTracks)
		XCTAssertEqual(collections.count, 2)

		let ids = collections.map(\.catalogMetadata.id)
		XCTAssertTrue(ids.contains("uct-1"))
		XCTAssertTrue(ids.contains("uct-2"))
	}

	// MARK: - Remove

	func testRemoveUserCollectionTracksDeletesFromLocalDatabase() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .userCollectionTracks, resourceId: "uct-123")
		await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try await offliner.getOfflineCollection(
			collectionType: .userCollectionTracks,
			resourceId: "uct-123"
		)
		XCTAssertNotNil(storedCollection)

		try await offliner.remove(collectionType: .userCollectionTracks, resourceId: "uct-123")
		await offliner.run()
		await backend.waitForTasksToComplete()

		let removedCollection = try await offliner.getOfflineCollection(
			collectionType: .userCollectionTracks,
			resourceId: "uct-123"
		)
		XCTAssertNil(removedCollection)
	}
}
