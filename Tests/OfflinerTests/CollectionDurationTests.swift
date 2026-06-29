@testable import Offliner
import TidalAPI
import XCTest

final class CollectionDurationTests: OfflinerTestCase {
	func testCollectionDurationSumsDurationsOfAllItems() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let albumId = "album-duration"

		backend.enqueueTasks([
			.storeAlbum(StoreAlbumTask(
				id: "task-collection",
				album: AlbumsResourceObject(id: albumId, type: "albums"),
				artists: [],
				artwork: nil
			)),
			.storeTrack(makeTrackTask(id: "task-1", trackId: "track-1", albumId: albumId, duration: "PT3M30S", volume: 1, position: 1)),
			.storeTrack(makeTrackTask(id: "task-2", trackId: "track-2", albumId: albumId, duration: "PT4M15S", volume: 1, position: 2)),
			.storeTrack(makeTrackTask(id: "task-3", trackId: "track-3", albumId: albumId, duration: "PT2M0S", volume: 1, position: 3)),
			.storeTrack(makeTrackTask(id: "task-4", trackId: "track-4", albumId: albumId, duration: "PT99H0M0S", volume: 1, position: 4)),
		])

		try await runAllTasks(offliner, backend: backend, expectedDownloads: 4)

		let duration = try await offliner.getCollectionDuration(collectionType: .albums, resourceId: .identifier(albumId))

		// 4 tracks × 120s (from SucceedingMediaDownloader) = 480s
		XCTAssertEqual(duration, 480)
	}

	func testCollectionDurationReturnsZeroForEmptyCollection() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let albumId = "album-empty"

		backend.enqueueTasks([
			.storeAlbum(StoreAlbumTask(
				id: "task-collection",
				album: AlbumsResourceObject(id: albumId, type: "albums"),
				artists: [],
				artwork: nil
			)),
		])

		await offliner.run()
		await backend.waitForTasksToComplete()

		let duration = try await offliner.getCollectionDuration(collectionType: .albums, resourceId: .identifier(albumId))
		XCTAssertEqual(duration, 0)
	}

	func testCollectionDurationReturnsZeroForNonexistentCollection() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let duration = try await offliner.getCollectionDuration(collectionType: .albums, resourceId: .identifier("nonexistent"))
		XCTAssertEqual(duration, 0)
	}

	// MARK: - Helpers

	private func makeTrackTask(
		id: String,
		trackId: String,
		albumId: String,
		duration: String,
		volume: Int,
		position: Int
	) -> StoreTrackTask {
		let attributes = TracksAttributes(
			duration: duration,
			explicit: false,
			isrc: "TEST00000001",
			key: .unknown,
			keyScale: .unknown,
			mediaTags: [],
			popularity: 0,
			title: "Track \(trackId)"
		)

		return StoreTrackTask(
			id: id,
			track: TracksResourceObject(attributes: attributes, id: trackId, type: "tracks"),
			artists: [],
			artwork: nil,
			collectionResourceType: "albums",
			collectionResourceId: albumId,
			volume: volume,
			position: position
		)
	}

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
}
