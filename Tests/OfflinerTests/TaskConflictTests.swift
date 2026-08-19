@testable import Offliner
import TidalAPI
import XCTest

final class TaskConflictTests: OfflinerTestCase {
	func testRemoveTaskForSameItemWaitsForRunningStoreTask() async throws {
		let backend = StubOfflineApiClient()
		let media = SuspendingMediaDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)

		backend.enqueueTasks([
			.storeTrack(storeTrackTask(id: "store-task", trackId: "track-123")),
			.removeItem(removeItemTask(id: "remove-task", trackId: "track-123")),
		])

		async let runTask: () = offliner.run()
		await media.waitUntilStarted()

		try await Task.sleep(nanoseconds: 200_000_000)
		XCTAssertEqual(backend.completedTaskIds, [])

		await media.complete()
		await backend.waitForTasksToComplete()
		await runTask

		XCTAssertEqual(backend.completedTaskIds, ["store-task", "remove-task"])

		let storedItem = try await offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-123"))
		XCTAssertNil(storedItem)
	}

	func testRemoveTaskForOtherItemRunsWhileStoreTaskIsRunning() async throws {
		let backend = StubOfflineApiClient()
		let media = SuspendingMediaDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)

		backend.enqueueTasks([
			.storeTrack(storeTrackTask(id: "store-task", trackId: "track-123")),
			.removeItem(removeItemTask(id: "remove-task", trackId: "track-456")),
		])

		async let runTask: () = offliner.run()
		await media.waitUntilStarted()

		while backend.completedTaskIds.isEmpty {
			try await Task.sleep(nanoseconds: 10_000_000)
		}
		XCTAssertEqual(backend.completedTaskIds, ["remove-task"])

		await media.complete()
		await backend.waitForTasksToComplete()
		await runTask
	}

	func testAlbumMemberStoresRunConcurrentlyWhileCollectionRemoveWaits() async throws {
		let backend = StubOfflineApiClient()
		let media = SelectiveSuspendingMediaDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)

		backend.enqueueTasks([
			.storeTrack(storeTrackTask(id: "store-1", trackId: "track-1", position: 1)),
			.storeTrack(storeTrackTask(id: "store-2", trackId: "track-2", position: 2)),
			.removeCollection(RemoveCollectionTask(id: "remove-album", resourceType: "albums", resourceId: "album-1")),
		])

		await offliner.run()
		await media.waitUntilStarted(count: 2)
		try await Task.sleep(nanoseconds: 100_000_000)
		XCTAssertFalse(backend.completedTaskIds.contains("remove-album"))

		await media.complete(taskId: "store-1")
		await media.complete(taskId: "store-2")
		await backend.waitForTasksToComplete()

		XCTAssertEqual(Set(backend.completedTaskIds.prefix(2)), Set(["store-1", "store-2"]))
		XCTAssertEqual(backend.completedTaskIds.last, "remove-album")
	}

	private func storeTrackTask(id: String, trackId: String, position: Int = 1) -> StoreTrackTask {
		StoreTrackTask(
			id: id,
			track: TracksResourceObject(id: trackId, type: "tracks"),
			artists: [],
			artwork: nil,
			collectionResourceType: "albums",
			collectionResourceId: "album-1",
			volume: 1,
			position: position
		)
	}

	private func removeItemTask(id: String, trackId: String) -> RemoveItemTask {
		RemoveItemTask(
			id: id,
			resourceType: "tracks",
			resourceId: trackId,
			collectionResourceType: "albums",
			collectionResourceId: "album-1"
		)
	}
}
