@testable import Offliner
import TidalAPI
import XCTest

// MARK: - CollectionEventsTests

final class CollectionEventsTests: OfflinerTestCase {
	private var backend: StubOfflineApiClient!
	private let album = OfflineCollectionReference(collectionType: .albums, resourceId: .identifier("album-1"))

	override func setUp() {
		super.setUp()
		backend = StubOfflineApiClient()
	}

	func testTaskFinishedIsEmittedAfterTheBackendUpdate() async throws {
		let offliner = makeOffliner()
		let recorder = EventRecorder(offliner.collectionEvents, backend: backend)
		backend.enqueueTasks([.storeAlbum(storeAlbumTask(id: "store-album"))])

		await offliner.run()
		let events = try await recorder.waitForEvents(count: 2)

		XCTAssertEqual(events.map(\.event), [
			OfflineCollectionEvent(collection: album, kind: .taskStarted),
			OfflineCollectionEvent(collection: album, kind: .taskFinished(succeeded: true)),
		])
		XCTAssertTrue(events[1].completedTaskIdsAtReceipt.contains("store-album"))
	}

	func testEverySubscriberReceivesEveryEvent() async throws {
		let offliner = makeOffliner()
		let first = EventRecorder(offliner.collectionEvents, backend: backend)
		let second = EventRecorder(offliner.collectionEvents, backend: backend)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-1"))
		let firstEvents = try await first.waitForEvents(count: 3).map(\.event)
		let secondEvents = try await second.waitForEvents(count: 3).map(\.event)

		let expected = [
			OfflineCollectionEvent(collection: album, kind: .requested),
			OfflineCollectionEvent(collection: album, kind: .taskStarted),
			OfflineCollectionEvent(collection: album, kind: .taskFinished(succeeded: true)),
		]
		XCTAssertEqual(firstEvents, expected)
		XCTAssertEqual(secondEvents, expected)
	}

	func testRemoveEmitsRemovedAndTheRemoveTaskEmitsTaskFinished() async throws {
		let offliner = makeOffliner()
		let recorder = EventRecorder(offliner.collectionEvents, backend: backend)

		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-1"))
		let events = try await recorder.waitForEvents(count: 3)

		XCTAssertEqual(events.map(\.event), [
			OfflineCollectionEvent(collection: album, kind: .removed),
			OfflineCollectionEvent(collection: album, kind: .taskStarted),
			OfflineCollectionEvent(collection: album, kind: .taskFinished(succeeded: true)),
		])
		// The stub names the remove task it creates for the removal "task-0".
		XCTAssertTrue(events[2].completedTaskIdsAtReceipt.contains("task-0"))
	}

	func testRemoveEmitsRemovedAndFailsQueuedDownloadsInTheSameCall() async throws {
		let media = GatedMediaDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)
		// Five tasks fill the runner's slots, so the album's track stays queued.
		let blockers = (1 ... 5).map { storeTrackTask(id: "blocker-\($0)", albumId: "album-other") }
		backend.enqueueTasks((blockers + [storeTrackTask(id: "queued")]).map { .storeTrack($0) })
		await offliner.run()
		await media.waitUntilStarted(count: 5)
		let currentDownloads = await offliner.currentDownloads
		let queued = try XCTUnwrap(currentDownloads.first { $0.relatedCollection == album })
		let recorder = EventRecorder(offliner.collectionEvents, backend: backend)

		try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-1"))

		// The download's stream finishes on failure, so this returns only if remove() already failed it.
		var states: [Download.State] = []
		for await case let .state(state) in queued.events {
			states.append(state)
		}
		XCTAssertEqual(states.last, .failed)
		let events = try await recorder.waitForEvents(count: 1)
		XCTAssertEqual(events.first?.event, OfflineCollectionEvent(collection: album, kind: .removed))
		await media.releaseAll()
	}

	func testFailedTrackTaskEmitsTaskFinishedForItsCollection() async throws {
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: FailingMediaDownloader()
		)
		let recorder = EventRecorder(offliner.collectionEvents, backend: backend)
		backend.enqueueTasks([.storeTrack(storeTrackTask(id: "store-track"))])

		await offliner.run()
		let events = try await recorder.waitForEvents(count: 2)

		XCTAssertEqual(events.map(\.event), [
			OfflineCollectionEvent(collection: album, kind: .taskStarted),
			OfflineCollectionEvent(collection: album, kind: .taskFinished(succeeded: false)),
		])
	}

	func testDownloadExposesItsRelatedCollection() async throws {
		let offliner = makeOffliner()
		let downloads = offliner.newDownloads
		backend.enqueueTasks([.storeTrack(storeTrackTask(id: "store-track"))])

		await offliner.run()
		var iterator = downloads.makeAsyncIterator()
		let download = await iterator.next()

		XCTAssertEqual(download?.relatedCollection, album)
	}

	// MARK: - Helpers

	private func makeOffliner() -> Offliner {
		createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
	}

	private func storeAlbumTask(id: String) -> StoreAlbumTask {
		StoreAlbumTask(id: id, album: AlbumsResourceObject(id: "album-1", type: "albums"), artists: [], artwork: nil)
	}

	private func storeTrackTask(id: String, albumId: String = "album-1") -> StoreTrackTask {
		StoreTrackTask(
			id: id,
			track: TracksResourceObject(id: "track-\(id)", type: "tracks"),
			artists: [],
			artwork: nil,
			collectionResourceType: "albums",
			collectionResourceId: albumId,
			volume: 1,
			position: 1
		)
	}
}

// MARK: - EventRecorder

/// Records events with the task ids the fake backend had marked completed when each event arrived.
private final class EventRecorder: @unchecked Sendable {
	struct Received {
		let event: OfflineCollectionEvent
		let completedTaskIdsAtReceipt: [String]
	}

	private let lock = NSLock()
	private var received: [Received] = []
	private var task: Task<Void, Never>?

	init(_ stream: AsyncStream<OfflineCollectionEvent>, backend: StubOfflineApiClient) {
		task = Task { [weak self] in
			for await event in stream {
				self?.append(Received(event: event, completedTaskIdsAtReceipt: backend.completedTaskIds))
			}
		}
	}

	deinit {
		task?.cancel()
	}

	private func append(_ event: Received) {
		lock.withLock { received.append(event) }
	}

	func waitForEvents(count: Int, timeout: TimeInterval = 5) async throws -> [Received] {
		let deadline = Date().addingTimeInterval(timeout)
		while lock.withLock({ received.count }) < count {
			guard Date() < deadline else {
				XCTFail("Timed out waiting for \(count) events, got \(lock.withLock { received })")
				break
			}
			try await Task.sleep(nanoseconds: 10_000_000)
		}
		return lock.withLock { received }
	}
}
