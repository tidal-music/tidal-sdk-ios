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

	private func storeTrackTask(id: String, trackId: String) -> StoreTrackTask {
		StoreTrackTask(
			id: id,
			track: TracksResourceObject(id: trackId, type: "tracks"),
			artists: [],
			artwork: nil,
			collectionResourceType: "albums",
			collectionResourceId: "album-1",
			volume: 1,
			position: 1
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
