@testable import Offliner
import TidalAPI
import XCTest

final class CollectionItemsTests: OfflinerTestCase {

	// MARK: - Happy Path: Album with tracks

	func testOfflineAlbumWithTracksReturnsAllItems() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let albumId = "album-1"

		let collectionTask = StoreAlbumTask(
			id: "offline-task-100",
			album: AlbumsResourceObject(id: albumId, type: "albums"),
			artists: [],
			artwork: nil
		)

		let itemTask1 = StoreTrackTask(
			id: "offline-task-101",
			track: TracksResourceObject(id: "track-1", type: "tracks"),
			artists: [],
			artwork: nil,
			collectionResourceType: "albums",
			collectionResourceId: albumId,
			volume: 1,
			position: 1
		)
		let itemTask2 = StoreTrackTask(
			id: "offline-task-102",
			track: TracksResourceObject(id: "track-2", type: "tracks"),
			artists: [],
			artwork: nil,
			collectionResourceType: "albums",
			collectionResourceId: albumId,
			volume: 1,
			position: 2
		)
		let itemTask3 = StoreTrackTask(
			id: "offline-task-103",
			track: TracksResourceObject(id: "track-3", type: "tracks"),
			artists: [],
			artwork: nil,
			collectionResourceType: "albums",
			collectionResourceId: albumId,
			volume: 1,
			position: 3
		)

		backend.enqueueTasks([
			.storeAlbum(collectionTask),
			.storeTrack(itemTask1),
			.storeTrack(itemTask2),
			.storeTrack(itemTask3),
		])

		try await runAllTasks(offliner, backend: backend, expectedDownloads: 3)

		let collection = try await offliner.getOfflineCollection(collectionType: .albums, resourceId: albumId)
		XCTAssertNotNil(collection, "Album collection should be stored")

		let page = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: albumId,
			limit: 100
		)

		XCTAssertEqual(page.items.count, 3, "Album should contain 3 tracks")
		guard page.items.count == 3 else { return }

		let trackIds = page.items.map(\.item.catalogMetadata.id)
		XCTAssertEqual(trackIds, ["track-1", "track-2", "track-3"])

		XCTAssertEqual(page.items[0].volume, 1)
		XCTAssertEqual(page.items[0].position, 1)
		XCTAssertEqual(page.items[1].volume, 1)
		XCTAssertEqual(page.items[1].position, 2)
		XCTAssertEqual(page.items[2].volume, 1)
		XCTAssertEqual(page.items[2].position, 3)
	}

	// MARK: - Empty collection

	func testGetCollectionItemsReturnsEmptyForCollectionWithNoItems() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let collectionTask = StoreAlbumTask(
			id: "empty-collection-task-id",
			album: AlbumsResourceObject(id: "album-empty", type: "albums"),
			artists: [],
			artwork: nil
		)

		backend.enqueueTasks([.storeAlbum(collectionTask)])

		try await offliner.run()
		await backend.waitForTasksToComplete()

		let page = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: "album-empty",
			limit: 100
		)
		XCTAssertEqual(page.items.count, 0)
		XCTAssertNil(page.cursor)
	}

	// MARK: - Pagination

	func testPaginationReturnsItemsInPages() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let albumId = "album-paginated"

		let collectionTask = StoreAlbumTask(
			id: "offline-task-200",
			album: AlbumsResourceObject(id: albumId, type: "albums"),
			artists: [],
			artwork: nil
		)

		var tasks: [OfflineTask] = [.storeAlbum(collectionTask)]
		for i in 1 ... 5 {
			tasks.append(.storeTrack(StoreTrackTask(
				id: "offline-task-20\(i)",
				track: TracksResourceObject(id: "track-\(i)", type: "tracks"),
				artists: [],
				artwork: nil,
				collectionResourceType: "albums",
				collectionResourceId: albumId,
				volume: 1,
				position: i
			)))
		}

		backend.enqueueTasks(tasks)
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 5)

		let page1 = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: albumId,
			limit: 2
		)
		XCTAssertEqual(page1.items.count, 2)
		XCTAssertEqual(page1.items.map(\.item.catalogMetadata.id), ["track-1", "track-2"])
		XCTAssertNotNil(page1.cursor)

		let page2 = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: albumId,
			limit: 2,
			after: page1.cursor
		)
		XCTAssertEqual(page2.items.count, 2)
		XCTAssertEqual(page2.items.map(\.item.catalogMetadata.id), ["track-3", "track-4"])
		XCTAssertNotNil(page2.cursor)

		let page3 = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: albumId,
			limit: 2,
			after: page2.cursor
		)
		XCTAssertEqual(page3.items.count, 1)
		XCTAssertEqual(page3.items.map(\.item.catalogMetadata.id), ["track-5"])
	}

	func testPaginationAcrossVolumes() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let albumId = "album-multi-vol"

		backend.enqueueTasks([
			.storeAlbum(StoreAlbumTask(
				id: "offline-task-300",
				album: AlbumsResourceObject(id: albumId, type: "albums"),
				artists: [],
				artwork: nil
			)),
			.storeTrack(StoreTrackTask(
				id: "offline-task-301",
				track: TracksResourceObject(id: "v1-track-1", type: "tracks"),
				artists: [],
				artwork: nil,
				collectionResourceType: "albums",
				collectionResourceId: albumId,
				volume: 1,
				position: 1
			)),
			.storeTrack(StoreTrackTask(
				id: "offline-task-302",
				track: TracksResourceObject(id: "v1-track-2", type: "tracks"),
				artists: [],
				artwork: nil,
				collectionResourceType: "albums",
				collectionResourceId: albumId,
				volume: 1,
				position: 2
			)),
			.storeTrack(StoreTrackTask(
				id: "offline-task-303",
				track: TracksResourceObject(id: "v2-track-1", type: "tracks"),
				artists: [],
				artwork: nil,
				collectionResourceType: "albums",
				collectionResourceId: albumId,
				volume: 2,
				position: 1
			)),
		])

		try await runAllTasks(offliner, backend: backend, expectedDownloads: 3)

		let page1 = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: albumId,
			limit: 2
		)
		XCTAssertEqual(page1.items.map(\.item.catalogMetadata.id), ["v1-track-1", "v1-track-2"])

		let page2 = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: albumId,
			limit: 2,
			after: page1.cursor
		)
		XCTAssertEqual(page2.items.count, 1)
		XCTAssertEqual(page2.items.map(\.item.catalogMetadata.id), ["v2-track-1"])
	}

	func testCursorIsNilWhenNoItems() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let albumId = "album-cursor"

		backend.enqueueTasks([
			.storeAlbum(StoreAlbumTask(
				id: "offline-task-400",
				album: AlbumsResourceObject(id: albumId, type: "albums"),
				artists: [],
				artwork: nil
			)),
		])

		try await offliner.run()
		await backend.waitForTasksToComplete()

		let page = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: albumId,
			limit: 10
		)

		XCTAssertTrue(page.items.isEmpty)
		XCTAssertNil(page.cursor)
	}

	func testCursorIsNonNilWhenItemsExist() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let albumId = "album-cursor"

		backend.enqueueTasks([
			.storeAlbum(StoreAlbumTask(
				id: "offline-task-400",
				album: AlbumsResourceObject(id: albumId, type: "albums"),
				artists: [],
				artwork: nil
			)),
			.storeTrack(StoreTrackTask(
				id: "offline-task-401",
				track: TracksResourceObject(id: "track-1", type: "tracks"),
				artists: [],
				artwork: nil,
				collectionResourceType: "albums",
				collectionResourceId: albumId,
				volume: 2,
				position: 3
			)),
		])

		try await runAllTasks(offliner, backend: backend, expectedDownloads: 1)

		let page = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: albumId,
			limit: 10
		)

		XCTAssertEqual(page.items.count, 1)
		XCTAssertNotNil(page.cursor)
	}

	// MARK: - Helpers

	private func runAllTasks(_ offliner: Offliner, backend: StubOfflineApiClient, expectedDownloads: Int) async throws {
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
