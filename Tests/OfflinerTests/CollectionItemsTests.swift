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

		let collectionTaskId = "offline-task-100"
		let collectionItemId = "item-album-1"
		let albumId = "album-1"

		let album = AlbumsResourceObject(id: albumId, type: "albums")
		let collectionTask = StoreCollectionTask(
			id: collectionTaskId,
			collection: collectionItemId,
			metadata: .album(AlbumMetadata(album: album, artists: [], coverArt: nil))
		)

		let track1 = TracksResourceObject(id: "track-1", type: "tracks")
		let track2 = TracksResourceObject(id: "track-2", type: "tracks")
		let track3 = TracksResourceObject(id: "track-3", type: "tracks")

		let itemTask1 = StoreItemTask(
			id: "offline-task-101",
			metadata: .track(TrackMetadata(track: track1, artists: [], coverArt: nil)),
			collection: collectionItemId,
			member: "item-track-1",
			volume: 1,
			position: 1
		)
		let itemTask2 = StoreItemTask(
			id: "offline-task-102",
			metadata: .track(TrackMetadata(track: track2, artists: [], coverArt: nil)),
			collection: collectionItemId,
			member: "item-track-2",
			volume: 1,
			position: 2
		)
		let itemTask3 = StoreItemTask(
			id: "offline-task-103",
			metadata: .track(TrackMetadata(track: track3, artists: [], coverArt: nil)),
			collection: collectionItemId,
			member: "item-track-3",
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

		let trackIds = items.map { item -> String in
			if case .track(let metadata) = item.item.metadata {
				return metadata.track.id
			}
			return ""
		}
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

		let album = AlbumsResourceObject(id: "album-empty", type: "albums")
		let collectionTask = StoreCollectionTask(
			id: "empty-collection-task-id",
			collection: "empty-collection-id",
			metadata: .album(AlbumMetadata(album: album, artists: [], coverArt: nil))
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

	private typealias TrackMetadata = OfflineMediaItem.TrackMetadata
	private typealias AlbumMetadata = OfflineCollection.AlbumMetadata
	private typealias PlaylistMetadata = OfflineCollection.PlaylistMetadata

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
