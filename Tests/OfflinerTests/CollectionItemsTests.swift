@testable import Offliner
import Foundation
import GRDB
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

		let collection = await offliner.getOfflineCollection(collectionType: .albums, resourceId: .identifier(albumId)).latest()
		XCTAssertNotNil(collection, "Album collection should be stored")

		let page = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: .identifier(albumId),
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

		await offliner.run()
		await backend.waitForTasksToComplete()

		let page = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: .identifier("album-empty"),
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
			resourceId: .identifier(albumId),
			limit: 2
		)
		XCTAssertEqual(page1.items.count, 2)
		XCTAssertEqual(page1.items.map(\.item.catalogMetadata.id), ["track-1", "track-2"])
		XCTAssertNotNil(page1.cursor)

		let page2 = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: .identifier(albumId),
			limit: 2,
			after: page1.cursor
		)
		XCTAssertEqual(page2.items.count, 2)
		XCTAssertEqual(page2.items.map(\.item.catalogMetadata.id), ["track-3", "track-4"])
		XCTAssertNotNil(page2.cursor)

		let page3 = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: .identifier(albumId),
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
			resourceId: .identifier(albumId),
			limit: 2
		)
		XCTAssertEqual(page1.items.map(\.item.catalogMetadata.id), ["v1-track-1", "v1-track-2"])

		let page2 = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: .identifier(albumId),
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

		await offliner.run()
		await backend.waitForTasksToComplete()

		let page = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: .identifier(albumId),
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
			resourceId: .identifier(albumId),
			limit: 10
		)

		XCTAssertEqual(page.items.count, 1)
		XCTAssertNotNil(page.cursor)
	}

	// MARK: - Sorting

	func testStoreTrackPersistsAlbumTitleForSorting() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let playlistId = "playlist-album-title"
		let addedAt = Date(timeIntervalSince1970: 1_767_225_600)
		backend.enqueueTasks([
			.storeTrack(StoreTrackTask(
				id: "offline-task-album-title",
				track: makeTrack(id: "track-album-title", title: "Track"),
				album: makeAlbum(id: "album-album-title", title: "Album Title"),
				artists: [],
				artwork: nil,
				collectionResourceType: "playlists",
				collectionResourceId: playlistId,
				volume: 1,
				position: 1,
				addedAt: addedAt
			)),
		])

		try await runAllTasks(offliner, backend: backend, expectedDownloads: 1)

		let page = try await offliner.getOfflineCollectionItems(
			collectionType: .playlists,
			resourceId: .identifier(playlistId),
			limit: 10
		)

		guard case .track(let metadata) = page.items.first?.item.catalogMetadata else {
			XCTFail("Expected track metadata")
			return
		}
		XCTAssertEqual(metadata.albumTitle, "Album Title")
		let storedAddedAt = try XCTUnwrap(page.items.first?.addedAt)
		XCTAssertEqual(storedAddedAt.timeIntervalSince1970, addedAt.timeIntervalSince1970, accuracy: 0.001)
	}

	func testSortByTitleAppliesBeforePagination() async throws {
		let (store, _) = try createStore()
		let playlistId = "playlist-title-sort"

		try storeTrack(store, id: "track-zulu", title: "Zulu", collectionId: playlistId, position: 1)
		try storeTrack(store, id: "track-alpha", title: "Alpha", collectionId: playlistId, position: 2)
		try storeTrack(store, id: "track-echo", title: "Echo", collectionId: playlistId, position: 3)
		try storeTrack(store, id: "track-bravo", title: "Bravo", collectionId: playlistId, position: 4)

		let (page1, failures1) = try await store.getCollectionItemsOrderByTitle(
			collectionType: .playlists,
			resourceId: playlistId,
			direction: .ascending,
			limit: 2
		)
		XCTAssertTrue(failures1.isEmpty)
		XCTAssertEqual(itemIds(in: page1), ["track-alpha", "track-bravo"])
		XCTAssertNotNil(page1.cursor)

		let (page2, failures2) = try await store.getCollectionItemsOrderByTitle(
			collectionType: .playlists,
			resourceId: playlistId,
			direction: .ascending,
			limit: 2,
			after: page1.cursor
		)
		XCTAssertTrue(failures2.isEmpty)
		XCTAssertEqual(itemIds(in: page2), ["track-echo", "track-zulu"])
	}

	func testSortByAlbumAscendingPlacesEmptyAlbumsFirst() async throws {
		let (store, _) = try createStore()
		let playlistId = "playlist-album-sort"

		try storeTrack(store, id: "track-beta", title: "Beta Track", albumTitle: "Beta Album", collectionId: playlistId, position: 1)
		try storeVideo(store, id: "video-no-album", title: "Video", collectionId: playlistId, position: 2)
		try storeTrack(store, id: "track-alpha", title: "Alpha Track", albumTitle: "Alpha Album", collectionId: playlistId, position: 3)

		let (page, failures) = try await store.getCollectionItemsOrderByAlbum(
			collectionType: .playlists,
			resourceId: playlistId,
			direction: .ascending,
			limit: 10
		)

		XCTAssertTrue(failures.isEmpty)
		// Missing album values sort as an empty string, i.e. first in ascending order.
		XCTAssertEqual(itemIds(in: page), ["video-no-album", "track-alpha", "track-beta"])
	}

	func testSortByArtistDescending() async throws {
		let (store, _) = try createStore()
		let playlistId = "playlist-artist-sort"

		try storeTrack(store, id: "track-alpha", title: "First", artists: ["Alpha Artist"], collectionId: playlistId, position: 1)
		try storeTrack(store, id: "track-zed", title: "Second", artists: ["Zed Artist"], collectionId: playlistId, position: 2)
		try storeTrack(store, id: "track-beta", title: "Third", artists: ["Beta Artist"], collectionId: playlistId, position: 3)

		let (page, failures) = try await store.getCollectionItemsOrderByArtist(
			collectionType: .playlists,
			resourceId: playlistId,
			direction: .descending,
			limit: 10
		)

		XCTAssertTrue(failures.isEmpty)
		XCTAssertEqual(itemIds(in: page), ["track-zed", "track-beta", "track-alpha"])
	}

	func testSortByDateAddedDescendingUsesRelationshipAddedAt() async throws {
		let (store, _) = try createStore()
		let playlistId = "playlist-date-sort"
		let oldest = Date(timeIntervalSince1970: 1_767_225_600)
		let middle = Date(timeIntervalSince1970: 1_767_312_000)
		let newest = Date(timeIntervalSince1970: 1_767_398_400)

		try storeTrack(store, id: "track-oldest", title: "Oldest", collectionId: playlistId, position: 1, addedAt: oldest)
		try storeTrack(store, id: "track-newest", title: "Newest", collectionId: playlistId, position: 2, addedAt: newest)
		try storeTrack(store, id: "track-middle", title: "Middle", collectionId: playlistId, position: 3, addedAt: middle)

		let (page, failures) = try await store.getCollectionItemsOrderByDateAdded(
			collectionType: .playlists,
			resourceId: playlistId,
			direction: .descending,
			limit: 10
		)

		XCTAssertTrue(failures.isEmpty)
		XCTAssertEqual(itemIds(in: page), ["track-newest", "track-middle", "track-oldest"])
	}

	func testSortByDateAddedDescendingPlacesMissingDatesLast() async throws {
		let (store, _) = try createStore()
		let playlistId = "playlist-date-sort-missing"

		try storeTrack(
			store,
			id: "track-with-date",
			title: "With Date",
			collectionId: playlistId,
			position: 1,
			addedAt: Date(timeIntervalSince1970: 1_767_225_600)
		)
		try storeTrack(store, id: "track-missing-date", title: "Missing Date", collectionId: playlistId, position: 2)

		let (page, failures) = try await store.getCollectionItemsOrderByDateAdded(
			collectionType: .playlists,
			resourceId: playlistId,
			direction: .descending,
			limit: 10
		)

		XCTAssertTrue(failures.isEmpty)
		XCTAssertEqual(itemIds(in: page), ["track-with-date", "track-missing-date"])
	}

	func testSortedPaginationSurvivesCursorItemDeletion() async throws {
		let (store, databaseQueue) = try createStore()
		let playlistId = "playlist-cursor-deletion"

		try storeTrack(store, id: "track-alpha", title: "Alpha", collectionId: playlistId, position: 1)
		try storeTrack(store, id: "track-bravo", title: "Bravo", collectionId: playlistId, position: 2)
		try storeTrack(store, id: "track-charlie", title: "Charlie", collectionId: playlistId, position: 3)

		let (page1, _) = try await store.getCollectionItemsOrderByTitle(
			collectionType: .playlists,
			resourceId: playlistId,
			direction: .ascending,
			limit: 1
		)
		XCTAssertEqual(itemIds(in: page1), ["track-alpha"])
		let cursor = try XCTUnwrap(page1.cursor)

		try await databaseQueue.write { db in
			try db.execute(
				sql: "DELETE FROM offline_item_relationship WHERE member_resource_id = ?",
				arguments: ["track-alpha"]
			)
		}

		let (page2, _) = try await store.getCollectionItemsOrderByTitle(
			collectionType: .playlists,
			resourceId: playlistId,
			direction: .ascending,
			limit: 10,
			after: cursor
		)
		XCTAssertEqual(itemIds(in: page2), ["track-bravo", "track-charlie"])
	}

	func testSortedUnparseableCursorIsIgnored() async throws {
		let (store, _) = try createStore()
		let playlistId = "playlist-bad-cursor"

		try storeTrack(store, id: "track-alpha", title: "Alpha", collectionId: playlistId, position: 1)
		try storeTrack(store, id: "track-bravo", title: "Bravo", collectionId: playlistId, position: 2)

		let (page, _) = try await store.getCollectionItemsOrderByTitle(
			collectionType: .playlists,
			resourceId: playlistId,
			direction: .ascending,
			limit: 10,
			after: "not-a-valid-cursor"
		)
		XCTAssertEqual(itemIds(in: page), ["track-alpha", "track-bravo"])
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

		await runTask
	}

	private func createStore() throws -> (OfflineStore, DatabaseQueue) {
		let dbPath = tempDir.appendingPathComponent("test-\(UUID().uuidString).sqlite").path
		let databaseQueue = try OfflineStore.makeDatabaseQueue(path: dbPath)
		try Migrations.run(databaseQueue)
		return (OfflineStore(databaseQueue), databaseQueue)
	}

	private func storeTrack(
		_ store: OfflineStore,
		id: String,
		title: String,
		artists: [String] = [],
		albumTitle: String? = nil,
		collectionId: String,
		position: Int,
		addedAt: Date? = nil
	) throws {
		try store.storeMediaItem(StoreItemTaskResult(
			resourceType: OfflineMediaItemType.tracks.rawValue,
			resourceId: id,
			catalogMetadata: .track(.init(
				id: id,
				title: title,
				artists: artists,
				albumTitle: albumTitle,
				duration: 120,
				explicit: false,
				backgroundColorHex: nil
			)),
			playbackMetadata: nil,
			collectionResourceType: OfflineCollectionType.playlists.rawValue,
			collectionResourceId: collectionId,
			volume: 1,
			position: position,
			addedAt: addedAt,
			mediaURL: mediaFileURL(for: id),
			licenseURL: nil,
			artworkURL: nil
		))
	}

	private func storeVideo(
		_ store: OfflineStore,
		id: String,
		title: String,
		artists: [String] = [],
		collectionId: String,
		position: Int,
		addedAt: Date? = nil
	) throws {
		try store.storeMediaItem(StoreItemTaskResult(
			resourceType: OfflineMediaItemType.videos.rawValue,
			resourceId: id,
			catalogMetadata: .video(.init(
				id: id,
				title: title,
				artists: artists,
				duration: 120,
				explicit: false
			)),
			playbackMetadata: nil,
			collectionResourceType: OfflineCollectionType.playlists.rawValue,
			collectionResourceId: collectionId,
			volume: 1,
			position: position,
			addedAt: addedAt,
			mediaURL: mediaFileURL(for: id),
			licenseURL: nil,
			artworkURL: nil
		))
	}

	private func mediaFileURL(for id: String) throws -> URL {
		let url = tempDir.appendingPathComponent("\(id).m4a")
		try Data(id.utf8).write(to: url)
		return url
	}

	private func itemIds(in page: OfflineCollectionItemsPage) -> [String] {
		page.items.map(\.item.catalogMetadata.id)
	}

	private func makeTrack(id: String, title: String) -> TracksResourceObject {
		TracksResourceObject(
			attributes: TracksAttributes(
				duration: "PT2M",
				explicit: false,
				isrc: "ISRC-\(id)",
				key: .c,
				keyScale: .major,
				mediaTags: [],
				popularity: 0,
				title: title
			),
			id: id,
			type: "tracks"
		)
	}

	private func makeAlbum(id: String, title: String) -> AlbumsResourceObject {
		AlbumsResourceObject(
			attributes: AlbumsAttributes(
				albumType: .album,
				barcodeId: "barcode-\(id)",
				duration: "PT2M",
				explicit: false,
				mediaTags: [],
				numberOfItems: 1,
				numberOfVolumes: 1,
				popularity: 0,
				title: title
			),
			id: id,
			type: "albums"
		)
	}
}
