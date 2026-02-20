@testable import Offliner
import TidalAPI
import XCTest

final class CollectionItemsTests: OfflinerTestCase {

	// MARK: - Happy Path: Album with tracks

	func testOfflineAlbumWithTracksReturnsAllItems() async throws {
		let backend = StubBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let albumId = "album-1"

		let collectionMetadata = BackendCollectionMetadata.album(AlbumsResourceObject(id: albumId, type: "albums"))

		let collectionTask = StoreCollectionTask(
			id: "offline-task-100",
			metadata: collectionMetadata,
			artists: [],
			artwork: nil
		)

		let itemTask1 = StoreItemTask(
			id: "offline-task-101",
			itemMetadata: .track(TracksResourceObject(id: "track-1", type: "tracks")),
			artists: [],
			artwork: nil,
			collectionMetadata: collectionMetadata,
			volume: 1,
			position: 1
		)
		let itemTask2 = StoreItemTask(
			id: "offline-task-102",
			itemMetadata: .track(TracksResourceObject(id: "track-2", type: "tracks")),
			artists: [],
			artwork: nil,
			collectionMetadata: collectionMetadata,
			volume: 1,
			position: 2
		)
		let itemTask3 = StoreItemTask(
			id: "offline-task-103",
			itemMetadata: .track(TracksResourceObject(id: "track-3", type: "tracks")),
			artists: [],
			artwork: nil,
			collectionMetadata: collectionMetadata,
			volume: 1,
			position: 3
		)

		backend.enqueueTasks([
			.storeCollection(collectionTask),
			.storeItem(itemTask1),
			.storeItem(itemTask2),
			.storeItem(itemTask3),
		])

		try await runAllTasks(offliner, backend: backend, expectedDownloads: 3)

		let collection = try offliner.getOfflineCollection(collectionType: .albums, resourceId: albumId)
		XCTAssertNotNil(collection, "Album collection should be stored")

		let items = try offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: albumId
		)

		XCTAssertEqual(items.count, 3, "Album should contain 3 tracks")
		guard items.count == 3 else { return }

		let trackIds = items.map(\.item.catalogMetadata.id)
		XCTAssertEqual(trackIds, ["track-1", "track-2", "track-3"])

		XCTAssertEqual(items[0].volume, 1)
		XCTAssertEqual(items[0].position, 1)
		XCTAssertEqual(items[1].volume, 1)
		XCTAssertEqual(items[1].position, 2)
		XCTAssertEqual(items[2].volume, 1)
		XCTAssertEqual(items[2].position, 3)
	}

	// MARK: - Empty collection

	func testGetCollectionItemsReturnsEmptyForCollectionWithNoItems() async throws {
		let backend = StubBackendClient()
		let offliner = createOffliner(
			backendClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let collectionTask = StoreCollectionTask(
			id: "empty-collection-task-id",
			metadata: .album(AlbumsResourceObject(id: "album-empty", type: "albums")),
			artists: [],
			artwork: nil
		)

		backend.enqueueTasks([.storeCollection(collectionTask)])

		try await offliner.run()
		await backend.waitForTasksToComplete()

		let items = try offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: "album-empty"
		)
		XCTAssertEqual(items.count, 0)
	}

	// MARK: - Helpers

	private func runAllTasks(_ offliner: Offliner, backend: StubBackendClient, expectedDownloads: Int) async throws {
		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		var downloadsList: [Download] = []
		for await download in downloads {
			downloadsList.append(download)
			if downloadsList.count == expectedDownloads { break }
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
	}
}
