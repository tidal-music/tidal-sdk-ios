@testable import Offliner
import Foundation
import TidalAPI
import XCTest

/// Regression coverage for the `TaskRunner` task-poll cursor.
///
/// The backend `/offline/tasks` endpoint is a *live* queue: it returns the current set of pending
/// tasks and drains as the client PATCHes them to `.completed`/`.failed`. A persistent,
/// monotonically-advancing page cursor (introduced by 2bb80702, "Use cursor for incremental task
/// fetching") skips tasks that shift toward the head as earlier ones complete, and never revisits
/// the head to pick up items enqueued after the queue has drained. That surfaced to users as
/// "can't download more than one page of a collection" and "newly-added tracks/playlists never
/// download".
///
/// Unlike `StubOfflineApiClient` (which always returns the full pending set with a nil cursor, so it
/// never exercises pagination), `PaginatingOfflineApiClient` models offset pagination over the
/// mutating queue — the shape that made the regression invisible to the existing suite.
final class TaskRunnerCursorRegressionTests: OfflinerTestCase {
	/// A newly-added track must download even after the queue has already drained once.
	/// This is the exact "newly-added tracks never download" report.
	func testNewlyAddedTrackDownloadsAfterQueueDrained() async throws {
		let backend = PaginatingOfflineApiClient(pageSize: 2)
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		// Initial collection: 3 tracks (spans two pages, so the buggy cursor advances off nil).
		try await backend.addItem(type: .track, id: "track-1")
		try await backend.addItem(type: .track, id: "track-2")
		try await backend.addItem(type: .track, id: "track-3")
		await offliner.run()
		try await awaitStoredTrackCount(offliner, expected: 3)

		// User adds one more track to the (already-downloaded) collection.
		try await backend.addItem(type: .track, id: "track-4-new")
		await offliner.run()
		try await awaitStoredTrackCount(offliner, expected: 4)
	}

	/// Every track of a multi-page collection must download, not just the first page.
	/// This is the "unable to download more than N tracks from collection" report.
	func testAllTracksOfMultiPageCollectionDownload() async throws {
		let backend = PaginatingOfflineApiClient(pageSize: 2)
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		for index in 1...5 {
			try await backend.addItem(type: .track, id: "track-\(index)")
		}
		await offliner.run()

		try await awaitStoredTrackCount(offliner, expected: 5)
	}

	// MARK: - Helpers

	/// Polls stored-track count up to a deadline, then asserts. A bounded wait is required because a
	/// regressed `TaskRunner` strands tasks, so the queue never fully drains.
	private func awaitStoredTrackCount(
		_ offliner: Offliner,
		expected: Int,
		timeout: TimeInterval = 10
	) async throws {
		let deadline = Date().addingTimeInterval(timeout)
		var lastCount = 0
		while Date() < deadline {
			lastCount = try await offliner.getOfflineMediaItems(mediaType: .tracks).count
			if lastCount >= expected { break }
			try? await Task.sleep(nanoseconds: 50_000_000)
		}
		XCTAssertEqual(lastCount, expected, "Expected \(expected) downloaded tracks, got \(lastCount)")
	}
}

// MARK: - PaginatingOfflineApiClient

/// Backend fake that models the real `/offline/tasks` contract: a pending-task queue paged by an
/// offset cursor, which drains as tasks are PATCHed to a terminal state.
private final class PaginatingOfflineApiClient: OfflineApiClientProtocol {
	private let pageSize: Int
	private var pending: [(id: String, task: OfflineTask)] = []
	private var taskIdCounter = 0

	init(pageSize: Int) {
		self.pageSize = pageSize
	}

	func addItem(type: ResourceType, id: String) async throws {
		let taskId = "task-\(taskIdCounter)"
		let position = taskIdCounter + 1
		taskIdCounter += 1

		let task: OfflineTask
		switch type {
		case .track:
			task = .storeTrack(StoreTrackTask(
				id: taskId,
				track: TracksResourceObject(id: id, type: "tracks"),
				artists: [],
				artwork: nil,
				collectionResourceType: "albums",
				collectionResourceId: "stub-album",
				volume: 1,
				position: position
			))
		default:
			return
		}
		pending.append((id: taskId, task: task))
	}

	func removeItem(type: ResourceType, id: String) async throws {}

	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) {
		let offset = cursor.flatMap(Int.init) ?? 0
		guard offset < pending.count else { return ([], nil) }
		let end = min(offset + pageSize, pending.count)
		let slice = pending[offset..<end].map(\.task)
		let nextCursor = end < pending.count ? String(end) : nil
		return (slice, nextCursor)
	}

	func updateTask(taskId: String, state: Download.State) async throws {
		if state == .completed || state == .failed {
			pending.removeAll { $0.id == taskId }
		}
	}
}
