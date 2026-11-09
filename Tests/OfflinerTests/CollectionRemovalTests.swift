@testable import Offliner
import GRDB
import TidalAPI
import XCTest

final class CollectionRemovalTests: OfflinerTestCase {
	private var backend: StubOfflineApiClient!

	override func setUp() {
		super.setUp()
		backend = StubOfflineApiClient()
	}

	// MARK: - Running and queued tasks

	func testRemovingWhileStoreAlbumRunsLeavesNoRow() async throws {
		let artwork = SuspendingArtworkDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: artwork,
			mediaDownloader: SucceedingMediaDownloader()
		)
		backend.enqueueTasks([.storeAlbum(storeAlbumTask(id: "store-album", albumId: "album-1"))])

		await offliner.run()
		await artwork.waitUntilStarted()

		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-1"))
		await artwork.complete()
		try await waitUntil { !self.backend.tasks.contains { $0.id == "store-album" } }

		let collection = try await OfflineStore(lastDatabaseQueue).getCollection(collectionType: .albums, resourceId: "album-1")
		XCTAssertNil(collection)
		XCTAssertFalse(backend.completedTaskIds.contains("store-album"))
		let lastArtworkURL = await artwork.lastURL
		let artworkURL = try XCTUnwrap(lastArtworkURL)
		XCTAssertFalse(FileManager.default.fileExists(atPath: artworkURL.path), "A rejected store must delete its artwork")
	}

	func testRemovingWhileStoreTrackRunsLeavesNoTrack() async throws {
		let media = GatedMediaDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)
		backend.enqueueTasks([.storeTrack(storeTrackTask(id: "store-track", trackId: "track-1", albumId: "album-1"))])

		await offliner.run()
		await media.waitUntilStarted(count: 1)

		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-1"))
		await media.releaseAll()
		try await waitUntil { !self.backend.tasks.contains { $0.id == "store-track" } }

		let track = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-1"))
		XCTAssertNil(track)
		let count = try await offliner.countOfflineCollectionItems(collectionType: .albums, resourceId: .identifier("album-1"))
		XCTAssertEqual(count, 0)
	}

	func testRemovingDropsQueuedTasksOfTheCollection() async throws {
		let media = GatedMediaDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)
		// Five tasks fill the runner's slots, so the album's tracks stay queued.
		let blockers = (1 ... 5).map { storeTrackTask(id: "blocker-\($0)", trackId: "other-\($0)", albumId: "album-other") }
		let queued = (1 ... 2).map { storeTrackTask(id: "queued-\($0)", trackId: "track-\($0)", albumId: "album-1") }
		backend.enqueueTasks((blockers + queued).map { .storeTrack($0) })

		await offliner.run()
		await media.waitUntilStarted(count: 5)

		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-1"))
		await media.releaseAll()
		try await waitUntil { Set(blockers.map(\.id)).isSubset(of: self.backend.completedTaskIds) }
		// The stub still lists the queued tasks, as the backend does until it deletes them. Let a refresh see them.
		await offliner.run()
		try await Task.sleep(nanoseconds: 100_000_000)

		let started = await media.startedTaskIds
		XCTAssertEqual(Set(started), Set(blockers.map(\.id)))
		let currentDownloads = await offliner.currentDownloads
		XCTAssertTrue(currentDownloads.isEmpty)
	}

	// MARK: - Pending inventory filter

	func testPendingInventoryEntryOfRemovedCollectionIsLeftOut() async throws {
		let offliner = makeOffliner()
		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-1"))

		backend.pendingCollectionsPages = [(collections: [pendingAlbum("album-1"), pendingAlbum("album-2")], cursor: nil)]
		let read = try await completeRead(offliner)
		XCTAssertEqual(read.map(\.catalogMetadata.id), ["album-2"])

		backend.pendingCollectionsPages = [(collections: [pendingAlbum("album-1")], cursor: nil)]
		var legacy: Set<OfflineCollection> = []
		for await collections in offliner.getOfflineCollections(collectionType: .albums) {
			legacy = collections
		}
		XCTAssertTrue(legacy.isEmpty)
	}

	func testCompleteReadWithoutTheCollectionClearsTheRemoval() async throws {
		let offliner = makeOffliner()
		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-1"))
		try await Task.sleep(nanoseconds: 5_000_000)

		backend.pendingCollectionsPages = [(collections: [pendingAlbum("album-1")], cursor: nil)]
		_ = try await completeRead(offliner)
		XCTAssertTrue(try isPendingRemoval("album-1"))

		backend.pendingCollectionsPages = []
		_ = try await completeRead(offliner)
		XCTAssertFalse(try isPendingRemoval("album-1"))

		backend.pendingCollectionsPages = [(collections: [pendingAlbum("album-1")], cursor: nil)]
		let read = try await completeRead(offliner)
		XCTAssertEqual(read.map(\.catalogMetadata.id), ["album-1"])
	}

	func testFailedReadKeepsTheRemoval() async throws {
		let offliner = makeOffliner()
		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-1"))
		try await Task.sleep(nanoseconds: 5_000_000)
		backend.pendingCollectionsFailingCall = 1

		do {
			for try await _ in offliner.offlineCollections(collectionType: .albums) {}
			XCTFail("Expected the read to throw")
		} catch {}

		XCTAssertTrue(try isPendingRemoval("album-1"))
	}

	func testRemovalSurvivesRecreatingTheOffliner() async throws {
		let offliner = makeOffliner()
		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-1"))

		let recreated = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader(),
			reusingDatabaseQueue: lastDatabaseQueue
		)
		backend.pendingCollectionsPages = [(collections: [pendingAlbum("album-1")], cursor: nil)]
		let read = try await completeRead(recreated)

		XCTAssertTrue(read.isEmpty)
	}

	func testDownloadingAgainAfterRemovalStoresAndListsTheCollection() async throws {
		let offliner = makeOffliner()
		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-1"))
		await offliner.run()
		await backend.waitForTasksToComplete()

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-1"))
		XCTAssertFalse(try isPendingRemoval("album-1"))

		backend.pendingCollectionsPages = [(collections: [pendingAlbum("album-1")], cursor: nil)]
		let pending = try await completeRead(offliner)
		XCTAssertEqual(pending.map(\.catalogMetadata.id), ["album-1"])

		await offliner.run()
		await backend.waitForTasksToComplete()
		let stored = try await completeRead(offliner)
		XCTAssertEqual(stored.map(\.catalogMetadata.id), ["album-1"])
		XCTAssertEqual(stored.first?.state, .stored)
	}

	// MARK: - Local delete

	func testFailedLocalDeleteThrows() async throws {
		let offliner = makeOffliner()
		try await lastDatabaseQueue.write { try $0.execute(sql: "ALTER TABLE offline_item RENAME TO offline_item_moved") }

		do {
			try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-1"))
			XCTFail("Expected the local delete to throw")
		} catch {
			XCTAssertEqual(backend.removedItems.map(\.id), ["album-1"])
		}
	}

	// MARK: - Helpers

	private func makeOffliner() -> Offliner {
		createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
	}

	private func pendingAlbum(_ id: String) -> OfflineCollection {
		.mock(catalogMetadata: .album(.mock(id: id)), artworkURL: nil, state: .pending)
	}

	private func isPendingRemoval(_ id: String) throws -> Bool {
		try OfflineStore(lastDatabaseQueue).isPendingRemoval(OfflineCollectionReference(collectionType: .albums, resourceId: id))
	}

	private func completeRead(_ offliner: Offliner) async throws -> [OfflineCollection] {
		var complete: [OfflineCollection]?
		for try await read in offliner.offlineCollections(collectionType: .albums) where read.isComplete {
			complete = read.collections
		}
		return try XCTUnwrap(complete)
	}

	private func waitUntil(timeout: TimeInterval = 5, _ condition: @escaping () -> Bool) async throws {
		let deadline = Date().addingTimeInterval(timeout)
		while !condition() {
			guard Date() < deadline else {
				XCTFail("Timed out waiting for condition")
				return
			}
			try await Task.sleep(nanoseconds: 10_000_000)
		}
	}

	private func storeAlbumTask(id: String, albumId: String) -> StoreAlbumTask {
		StoreAlbumTask(id: id, album: AlbumsResourceObject(id: albumId, type: "albums"), artists: [], artwork: nil)
	}

	private func storeTrackTask(id: String, trackId: String, albumId: String) -> StoreTrackTask {
		StoreTrackTask(
			id: id,
			track: TracksResourceObject(id: trackId, type: "tracks"),
			artists: [],
			artwork: nil,
			collectionResourceType: "albums",
			collectionResourceId: albumId,
			volume: 1,
			position: 1
		)
	}
}
