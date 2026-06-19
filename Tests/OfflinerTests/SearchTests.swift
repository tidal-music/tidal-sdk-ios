@testable import Offliner
import TidalAPI
import XCTest

final class SearchTests: OfflinerTestCase {

	// MARK: - Matching

	func testFindMatchesTitleCaseInsensitively() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Lemonade", artistNames: ["Beyoncé"])),
			.storeTrack(trackTask(id: "task-1", trackId: "track-1", albumId: albumId, title: "Halo", artistNames: [], position: 1)),
			.storeTrack(trackTask(id: "task-2", trackId: "track-2", albumId: albumId, title: "Sorry", artistNames: [], position: 2)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 2)

		let hits = try await offliner.findInOfflineCollection(search: "halo", collectionType: .albums, resourceId: .identifier(albumId)).hits
		XCTAssertEqual(hits.map(\.item.item.catalogMetadata.id), ["track-1"])
	}

	func testFindMatchesAssociatedArtist() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Compilation", artistNames: [])),
			.storeTrack(trackTask(id: "task-1", trackId: "track-1", albumId: albumId, title: "One", artistNames: ["Daft Punk"], position: 1)),
			.storeTrack(trackTask(id: "task-2", trackId: "track-2", albumId: albumId, title: "Two", artistNames: ["Justice"], position: 2)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 2)

		let hits = try await offliner.findInOfflineCollection(search: "daft", collectionType: .albums, resourceId: .identifier(albumId)).hits
		XCTAssertEqual(hits.map(\.item.item.catalogMetadata.id), ["track-1"])
	}

	func testFindMatchesAnyCreditedArtist() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Compilation", artistNames: [])),
			.storeTrack(trackTask(
				id: "task-1",
				trackId: "track-1",
				albumId: albumId,
				title: "One Kiss",
				artistNames: ["Calvin Harris", "Dua Lipa"],
				position: 1
			)),
			.storeTrack(trackTask(id: "task-2", trackId: "track-2", albumId: albumId, title: "Two", artistNames: ["Justice"], position: 2)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 2)

		// `artist_sort` stores every credited artist as a comma-separated list, so a secondary artist matches too.
		let hits = try await offliner.findInOfflineCollection(search: "dua", collectionType: .albums, resourceId: .identifier(albumId)).hits
		XCTAssertEqual(hits.map(\.item.item.catalogMetadata.id), ["track-1"])
	}

	func testFindReturnsOnlyItemsFromTargetCollection() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumA = "album-A"
		let albumB = "album-B"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-a0", albumId: albumA, title: "A", artistNames: [])),
			.storeTrack(trackTask(id: "task-a1", trackId: "track-A1", albumId: albumA, title: "Halo", artistNames: [], position: 1)),
			.storeTrack(trackTask(id: "task-a2", trackId: "track-A2", albumId: albumA, title: "Other", artistNames: [], position: 2)),
			.storeAlbum(albumTask(id: "task-b0", albumId: albumB, title: "B", artistNames: [])),
			.storeTrack(trackTask(id: "task-b1", trackId: "track-B1", albumId: albumB, title: "Halo", artistNames: [], position: 1)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 3)

		let hits = try await offliner.findInOfflineCollection(search: "halo", collectionType: .albums, resourceId: .identifier(albumA)).hits
		XCTAssertEqual(hits.map(\.item.item.catalogMetadata.id), ["track-A1"])
	}

	func testFindMatchesArtistIgnoringAccents() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Lemonade", artistNames: ["Beyoncé"])),
			.storeTrack(trackTask(id: "task-1", trackId: "track-1", albumId: albumId, title: "Halo", artistNames: ["Beyoncé"], position: 1)),
			.storeTrack(trackTask(id: "task-2", trackId: "track-2", albumId: albumId, title: "Sorry", artistNames: ["Justice"], position: 2)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 2)

		// Query without the accent matches the accented artist name.
		let unaccentedHits = try await offliner
			.findInOfflineCollection(search: "beyonce", collectionType: .albums, resourceId: .identifier(albumId)).hits
		XCTAssertEqual(unaccentedHits.map(\.item.item.catalogMetadata.id), ["track-1"])

		// Query with the accent still matches.
		let accentedHits = try await offliner
			.findInOfflineCollection(search: "beyoncé", collectionType: .albums, resourceId: .identifier(albumId)).hits
		XCTAssertEqual(accentedHits.map(\.item.item.catalogMetadata.id), ["track-1"])
	}

	func testFindMatchesTitleIgnoringAccents() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Compilation", artistNames: [])),
			.storeTrack(trackTask(id: "task-1", trackId: "track-1", albumId: albumId, title: "Déjà Vu", artistNames: [], position: 1)),
			.storeTrack(trackTask(id: "task-2", trackId: "track-2", albumId: albumId, title: "Sorry", artistNames: [], position: 2)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 2)

		let hits = try await offliner
			.findInOfflineCollection(search: "deja vu", collectionType: .albums, resourceId: .identifier(albumId)).hits
		XCTAssertEqual(hits.map(\.item.item.catalogMetadata.id), ["track-1"])
	}

	func testFindDoesNotReturnTheCollectionItself() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Halo", artistNames: [])),
			.storeTrack(trackTask(id: "task-1", trackId: "track-1", albumId: albumId, title: "Other", artistNames: [], position: 1)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 1)

		let hits = try await offliner.findInOfflineCollection(search: "halo", collectionType: .albums, resourceId: .identifier(albumId)).hits
		XCTAssertTrue(hits.isEmpty)
	}

	func testFindReturnsEmptyForBlankQuery() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Title", artistNames: [])),
			.storeTrack(trackTask(id: "task-1", trackId: "track-1", albumId: albumId, title: "Track", artistNames: [], position: 1)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 1)

		let hits = try await offliner.findInOfflineCollection(search: "   ", collectionType: .albums, resourceId: .identifier(albumId)).hits
		XCTAssertTrue(hits.isEmpty)
	}

	func testFindDoesNotReturnDeletedTracks() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Album", artistNames: [])),
			.storeTrack(trackTask(id: "task-1", trackId: "track-1", albumId: albumId, title: "Halo", artistNames: [], position: 1)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 1)

		var hits = try await offliner.findInOfflineCollection(search: "halo", collectionType: .albums, resourceId: .identifier(albumId)).hits
		XCTAssertEqual(hits.count, 1)

		backend.enqueueTasks([.removeItem(RemoveItemTask(
			id: "task-99",
			resourceType: OfflineMediaItemType.tracks.rawValue,
			resourceId: "track-1",
			collectionResourceType: OfflineCollectionType.albums.rawValue,
			collectionResourceId: albumId
		))])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 0)

		hits = try await offliner.findInOfflineCollection(search: "halo", collectionType: .albums, resourceId: .identifier(albumId)).hits
		XCTAssertTrue(hits.isEmpty)
	}

	// MARK: - Cursor: next page in the supplied sort order

	func testHitCursorReturnsSubsequentItemsInNaturalOrder() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		var enqueued: [OfflineTask] = [.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Album", artistNames: []))]
		for index in 1 ... 10 {
			let title = index == 7 ? "Needle" : "Track \(index)"
			enqueued.append(.storeTrack(trackTask(
				id: "task-\(index)", trackId: "track-\(index)", albumId: albumId, title: title, artistNames: [], position: index
			)))
		}
		backend.enqueueTasks(enqueued)
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 10)

		let hits = try await offliner.findInOfflineCollection(search: "needle", collectionType: .albums, resourceId: .identifier(albumId)).hits
		let hit = try XCTUnwrap(hits.first)
		XCTAssertEqual(hit.item.item.catalogMetadata.id, "track-7")

		let page = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: .identifier(albumId),
			limit: 3,
			after: hit.cursor
		)
		XCTAssertEqual(page.items.map(\.item.catalogMetadata.id), ["track-8", "track-9", "track-10"])
	}

	func testHitCursorReturnsSubsequentItemsInTitleSortOrder() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Album", artistNames: [])),
			.storeTrack(trackTask(id: "task-1", trackId: "track-cherry", albumId: albumId, title: "Cherry", artistNames: [], position: 1)),
			.storeTrack(trackTask(id: "task-2", trackId: "track-apple", albumId: albumId, title: "Apple", artistNames: [], position: 2)),
			.storeTrack(trackTask(id: "task-3", trackId: "track-elder", albumId: albumId, title: "Elder", artistNames: [], position: 3)),
			.storeTrack(trackTask(id: "task-4", trackId: "track-banana", albumId: albumId, title: "Banana", artistNames: [], position: 4)),
			.storeTrack(trackTask(id: "task-5", trackId: "track-date", albumId: albumId, title: "Date", artistNames: [], position: 5)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 5)

		let sort = OfflineCollectionItemSort.title(direction: .ascending)
		let hits = try await offliner.findInOfflineCollection(
			search: "cherry",
			collectionType: .albums,
			resourceId: .identifier(albumId),
			sort: sort
		).hits
		let hit = try XCTUnwrap(hits.first)
		XCTAssertEqual(hit.item.item.catalogMetadata.id, "track-cherry")

		let page = try await offliner.getOfflineCollectionItems(
			collectionType: .albums,
			resourceId: .identifier(albumId),
			limit: 10,
			sort: sort,
			after: hit.cursor
		)
		XCTAssertEqual(page.items.map(\.item.catalogMetadata.id), ["track-date", "track-elder"])
	}

	func testHitsAreOrderedBySuppliedSort() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Album", artistNames: [])),
			.storeTrack(trackTask(id: "task-1", trackId: "track-1", albumId: albumId, title: "Song Beta", artistNames: [], position: 1)),
			.storeTrack(trackTask(id: "task-2", trackId: "track-2", albumId: albumId, title: "Song Alpha", artistNames: [], position: 2)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 2)

		let hits = try await offliner.findInOfflineCollection(
			search: "song",
			collectionType: .albums,
			resourceId: .identifier(albumId),
			sort: .title(direction: .ascending)
		).hits
		XCTAssertEqual(hits.map(\.item.item.catalogMetadata.id), ["track-2", "track-1"])
	}

	func testFindLimitsHitsToTwentyByDefault() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		var enqueued: [OfflineTask] = [.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Album", artistNames: []))]
		for index in 1 ... 25 {
			enqueued.append(.storeTrack(trackTask(
				id: "task-\(index)", trackId: "track-\(index)", albumId: albumId, title: "Song \(index)", artistNames: [], position: index
			)))
		}
		backend.enqueueTasks(enqueued)
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 25)

		let hits = try await offliner.findInOfflineCollection(search: "song", collectionType: .albums, resourceId: .identifier(albumId)).hits
		XCTAssertEqual(hits.count, 20)
	}

	func testFindRespectsCustomLimit() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		var enqueued: [OfflineTask] = [.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Album", artistNames: []))]
		for index in 1 ... 10 {
			enqueued.append(.storeTrack(trackTask(
				id: "task-\(index)", trackId: "track-\(index)", albumId: albumId, title: "Song \(index)", artistNames: [], position: index
			)))
		}
		backend.enqueueTasks(enqueued)
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 10)

		let hits = try await offliner.findInOfflineCollection(
			search: "song",
			collectionType: .albums,
			resourceId: .identifier(albumId),
			limit: 3
		).hits
		XCTAssertEqual(hits.count, 3)
	}

	// MARK: - Pagination

	func testSearchPaginatesWithCursorInNaturalOrder() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		var enqueued: [OfflineTask] = [.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Album", artistNames: []))]
		for index in 1 ... 25 {
			enqueued.append(.storeTrack(trackTask(
				id: "task-\(index)", trackId: "track-\(index)", albumId: albumId, title: "Song \(index)", artistNames: [], position: index
			)))
		}
		backend.enqueueTasks(enqueued)
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 25)

		let first = try await offliner.findInOfflineCollection(search: "song", collectionType: .albums, resourceId: .identifier(albumId))
		XCTAssertEqual(first.hits.count, 20)
		let cursor = try XCTUnwrap(first.cursor)

		let second = try await offliner.findInOfflineCollection(
			search: "song",
			collectionType: .albums,
			resourceId: .identifier(albumId),
			after: cursor
		)
		XCTAssertEqual(second.hits.count, 5)

		let firstIds = first.hits.map(\.item.item.catalogMetadata.id)
		let secondIds = second.hits.map(\.item.item.catalogMetadata.id)
		XCTAssertTrue(Set(firstIds).isDisjoint(with: Set(secondIds)))
		XCTAssertEqual(Set(firstIds).count + Set(secondIds).count, 25)
	}

	func testSearchPagesThroughAllResultsInTitleSortOrder() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let titles = ["Song Echo", "Song Delta", "Song Charlie", "Song Bravo", "Song Alpha"]
		let albumId = "album-1"
		var enqueued: [OfflineTask] = [.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Album", artistNames: []))]
		for (index, title) in titles.enumerated() {
			enqueued.append(.storeTrack(trackTask(
				id: "task-\(index)", trackId: "track-\(index)", albumId: albumId, title: title, artistNames: [], position: index + 1
			)))
		}
		backend.enqueueTasks(enqueued)
		try await runAllTasks(offliner, backend: backend, expectedDownloads: titles.count)

		let sort = OfflineCollectionItemSort.title(direction: .ascending)
		var collected: [String] = []
		var pageSizes: [Int] = []
		var cursor: String?

		while true {
			let page = try await offliner.findInOfflineCollection(
				search: "song",
				collectionType: .albums,
				resourceId: .identifier(albumId),
				sort: sort,
				limit: 2,
				after: cursor
			)
			if page.hits.isEmpty { break }
			pageSizes.append(page.hits.count)
			collected += page.hits.map(\.item.item.catalogMetadata.id)
			cursor = page.cursor
		}

		XCTAssertEqual(pageSizes, [2, 2, 1])
		XCTAssertEqual(collected, ["track-4", "track-3", "track-2", "track-1", "track-0"])
	}

	// MARK: - Removing a collection reclaims orphaned members

	func testRemovingCollectionDeletesOrphanedMembers() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumId = "album-1"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-0", albumId: albumId, title: "Album", artistNames: [])),
			.storeTrack(trackTask(id: "task-1", trackId: "track-1", albumId: albumId, title: "Halo", artistNames: [], position: 1)),
			.storeTrack(trackTask(id: "task-2", trackId: "track-2", albumId: albumId, title: "Sorry", artistNames: [], position: 2)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 2)

		backend.enqueueTasks([.removeCollection(RemoveCollectionTask(
			id: "task-99",
			resourceType: OfflineCollectionType.albums.rawValue,
			resourceId: albumId
		))])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 0)

		let track1 = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-1"))
		let track2 = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-2"))
		XCTAssertNil(track1)
		XCTAssertNil(track2)
	}

	func testRemovingCollectionKeepsMembersSharedWithAnotherCollection() async throws {
		let backend = StubOfflineApiClient()
		let offliner = makeOffliner(backend)

		let albumA = "album-A"
		let albumB = "album-B"
		backend.enqueueTasks([
			.storeAlbum(albumTask(id: "task-a0", albumId: albumA, title: "A", artistNames: [])),
			.storeAlbum(albumTask(id: "task-b0", albumId: albumB, title: "B", artistNames: [])),
			.storeTrack(trackTask(id: "task-s-a", trackId: "track-shared", albumId: albumA, title: "Halo", artistNames: [], position: 1)),
			.storeTrack(trackTask(id: "task-s-b", trackId: "track-shared", albumId: albumB, title: "Halo", artistNames: [], position: 1)),
			.storeTrack(trackTask(id: "task-a1", trackId: "track-onlyA", albumId: albumA, title: "Solo", artistNames: [], position: 2)),
		])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 3)

		backend.enqueueTasks([.removeCollection(RemoveCollectionTask(
			id: "task-99",
			resourceType: OfflineCollectionType.albums.rawValue,
			resourceId: albumA
		))])
		try await runAllTasks(offliner, backend: backend, expectedDownloads: 0)

		let onlyA = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-onlyA"))
		let shared = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-shared"))
		XCTAssertNil(onlyA)
		XCTAssertNotNil(shared)

		let hits = try await offliner.findInOfflineCollection(search: "halo", collectionType: .albums, resourceId: .identifier(albumB)).hits
		XCTAssertEqual(hits.map(\.item.item.catalogMetadata.id), ["track-shared"])
	}

	// MARK: - Helpers

	private func makeOffliner(_ backend: StubOfflineApiClient) -> Offliner {
		createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
	}

	private func runAllTasks(_ offliner: Offliner, backend: StubOfflineApiClient, expectedDownloads: Int) async throws {
		let downloads = offliner.newDownloads
		await offliner.run()

		if expectedDownloads > 0 {
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
		}

		await backend.waitForTasksToComplete()
	}

	private func trackTask(
		id: String,
		trackId: String,
		albumId: String,
		title: String,
		artistNames: [String],
		position: Int
	) -> StoreTrackTask {
		StoreTrackTask(
			id: id,
			track: TracksResourceObject(
				attributes: TracksAttributes(
					duration: "PT3M0S",
					explicit: false,
					isrc: "TEST00000001",
					key: .unknown,
					keyScale: .unknown,
					mediaTags: [],
					popularity: 0,
					title: title
				),
				id: trackId,
				type: "tracks"
			),
			artists: artistNames.enumerated().map { index, name in
				ArtistsResourceObject(
					attributes: ArtistsAttributes(name: name, popularity: 0),
					id: "artist-\(trackId)-\(index)",
					type: "artists"
				)
			},
			artwork: nil,
			collectionResourceType: OfflineCollectionType.albums.rawValue,
			collectionResourceId: albumId,
			volume: 1,
			position: position
		)
	}

	private func albumTask(
		id: String,
		albumId: String,
		title: String,
		artistNames: [String]
	) -> StoreAlbumTask {
		StoreAlbumTask(
			id: id,
			album: AlbumsResourceObject(
				attributes: AlbumsAttributes(
					albumType: .album,
					barcodeId: "BARCODE",
					duration: "PT30M0S",
					explicit: false,
					mediaTags: [],
					numberOfItems: 1,
					numberOfVolumes: 1,
					popularity: 0,
					title: title
				),
				id: albumId,
				type: "albums"
			),
			artists: artistNames.enumerated().map { index, name in
				ArtistsResourceObject(
					attributes: ArtistsAttributes(name: name, popularity: 0),
					id: "artist-\(albumId)-\(index)",
					type: "artists"
				)
			},
			artwork: nil
		)
	}
}
