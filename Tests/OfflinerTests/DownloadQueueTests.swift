@testable import Offliner
import TidalAPI
import XCTest

// MARK: - DownloadQueueTests

final class DownloadQueueTests: OfflinerTestCase {
	func testSnapshotWaitsForBackendSynchronization() async throws {
		let backend = BlockingGetTasksOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		let snapshotTask = Task { try await offliner.getOfflineDownloadQueue() }

		await backend.waitUntilRequested()
		XCTAssertFalse(snapshotTask.isCancelled)
		await backend.resume(with: [.storeAlbum(storeAlbumTask(id: "album-task"))])

		let snapshot = try await snapshotTask.value
		XCTAssertEqual(snapshot, [OfflineDownloadQueueEntry(
			resource: .collection(type: .albums, resourceId: "album-1"),
			parentCollection: nil,
			state: .queued,
			progress: nil
		)])
	}

	func testSnapshotPreservesSynchronizationError() async {
		let offliner = createOffliner(
			offlineApiClient: FailOnGetTasksOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		await XCTAssertThrowsErrorAsync {
			_ = try await offliner.getOfflineDownloadQueue()
		}
	}

	func testObservationBroadcastsDistinctProgressAndCompletionToEverySubscriber() async throws {
		let backend = StubOfflineApiClient()
		let media = SucceedingMediaDownloader()
		media.progressValues = [0.25, 0.25, 0.75]
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)
		var first = offliner.observeOfflineDownloadQueue().makeAsyncIterator()
		var second = offliner.observeOfflineDownloadQueue().makeAsyncIterator()
		let firstInitial = try await first.next()
		let secondInitial = try await second.next()
		XCTAssertEqual(firstInitial, [])
		XCTAssertEqual(secondInitial, [])

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-1"))
		let firstQueued = try await first.next()
		let secondQueued = try await second.next()
		XCTAssertEqual(firstQueued, secondQueued)
		XCTAssertEqual(firstQueued?.first?.state, .queued)

		await offliner.run()
		await backend.waitForTasksToComplete()
		let firstUpdates = try await collectUntilEmpty(&first)
		let secondUpdates = try await collectUntilEmpty(&second)

		XCTAssertEqual(firstUpdates, secondUpdates)
		XCTAssertTrue(firstUpdates.contains { $0.first?.state == .downloading })
		XCTAssertEqual(firstUpdates.filter { $0.first?.progress == 0.25 }.count, 1)
		XCTAssertTrue(firstUpdates.contains { $0.first?.progress == 0.75 })
		XCTAssertEqual(firstUpdates.last, [])
	}

	func testObservationFinishesOnReset() async throws {
		let offliner = createOffliner(
			offlineApiClient: HoldingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		var iterator = offliner.observeOfflineDownloadQueue().makeAsyncIterator()
		let initial = try await iterator.next()
		XCTAssertEqual(initial, [])

		try await offliner.reset()

		let afterReset = try await iterator.next()
		XCTAssertNil(afterReset)
	}

	func testCancelledObservationFinishesOnlyThatSubscriber() async throws {
		let backend = HoldingOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		let started = expectation(description: "subscriber started")
		let cancelledConsumer = Task {
			do {
				for try await _ in offliner.observeOfflineDownloadQueue() {
					started.fulfill()
				}
			} catch is CancellationError {
				// Expected.
			}
		}
		await fulfillment(of: [started])
		cancelledConsumer.cancel()
		try await cancelledConsumer.value

		var remaining = offliner.observeOfflineDownloadQueue().makeAsyncIterator()
		let initial = try await remaining.next()
		XCTAssertEqual(initial, [])
		try await offliner.download(mediaType: .videos, resourceId: .identifier("video-1"))
		let queued = try await remaining.next()
		XCTAssertEqual(queued?.first?.resource, .media(type: .videos, resourceId: "video-1"))
	}

	func testCollectionMetadataAndMembersAggregateAsOneEntry() async throws {
		let backend = StubOfflineApiClient()
		backend.enqueueTasks([
			.storeTrack(storeTrackTask(id: "track-1", trackId: "track-1", position: 1)),
			.storeTrack(storeTrackTask(id: "track-2", trackId: "track-2", position: 2)),
			.storeAlbum(storeAlbumTask(id: "album-metadata")),
		])
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let snapshot = try await offliner.getOfflineDownloadQueue()

		XCTAssertEqual(snapshot.count, 1)
		XCTAssertEqual(snapshot.first?.resource, .collection(type: .albums, resourceId: "album-1"))
		XCTAssertNil(snapshot.first?.parentCollection)
		XCTAssertEqual(snapshot.first?.state, .queued)
	}

	func testTerminalCollectionMetadataDoesNotAbsorbStandaloneMedia() async throws {
		let backend = StubOfflineApiClient()
		let media = SuspendingMediaDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)
		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-1"))
		backend.enqueueTasks([.terminal(TerminalOfflineTask(
			id: "historical-album-metadata",
			state: .completed,
			action: .store,
			resourceType: "albums",
			resourceId: "stub-album",
			collectionResourceType: nil,
			collectionResourceId: nil
		))])
		await media.waitUntilStarted()

		let snapshot = try await offliner.getOfflineDownloadQueue()

		XCTAssertEqual(snapshot.count, 1)
		XCTAssertEqual(snapshot.first?.resource, .media(type: .tracks, resourceId: "track-1"))
		XCTAssertEqual(snapshot.first?.parentCollection, .collection(type: .albums, resourceId: "stub-album"))
		XCTAssertEqual(snapshot.first?.state, .downloading)
	}

	func testCollectionMetadataFailureRemainsInQueue() async throws {
		let backend = StubOfflineApiClient()
		backend.enqueueTasks([.storeAlbum(storeAlbumTask(id: "album-metadata"))])
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: FailingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		await offliner.run()
		await backend.waitForTasksToComplete()
		let snapshot = try await offliner.getOfflineDownloadQueue()

		XCTAssertEqual(snapshot.count, 1)
		XCTAssertEqual(snapshot.first?.resource, .collection(type: .albums, resourceId: "album-1"))
		XCTAssertEqual(snapshot.first?.state, .failed(action: .download))
	}

	func testFailedCollectionMemberSurvivesLaterSiblingCompletion() async throws {
		let backend = StubOfflineApiClient()
		let media = SelectiveSuspendingMediaDownloader(failingTaskIds: ["failing-track"])
		backend.enqueueTasks([
			.storeTrack(storeTrackTask(id: "failing-track", trackId: "track-1", position: 1)),
			.storeTrack(storeTrackTask(id: "succeeding-track", trackId: "track-2", position: 2)),
		])
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)

		await offliner.run()
		await media.waitUntilStarted(count: 2)
		await media.complete(taskId: "succeeding-track")
		await backend.waitForTasksToComplete()
		let snapshot = try await offliner.getOfflineDownloadQueue()

		XCTAssertEqual(snapshot.count, 1)
		XCTAssertEqual(snapshot.first?.resource, .collection(type: .albums, resourceId: "album-1"))
		XCTAssertEqual(snapshot.first?.state, .failed(action: .download))
	}

	func testStandaloneMediaFailurePersistsAcrossRecreationWithRetryIdentity() async throws {
		let installationId = "failed-media-queue"
		let backend = StubOfflineApiClient()
		var first: Offliner? = Offliner(
			storage: try OfflinerStorage(installationId: installationId, baseDirectory: tempDir),
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: FailingMediaDownloader(),
			trackManifestFetcher: SucceedingTrackManifestFetcher(),
			videoManifestFetcher: SucceedingVideoManifestFetcher()
		)
		try await first?.download(mediaType: .tracks, resourceId: .identifier("track-1"))
		await first?.run()
		await backend.waitForTasksToComplete()
		first = nil

		let second = createOffliner(
			installationId: installationId,
			offlineApiClient: HoldingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		let snapshot = try await second.getOfflineDownloadQueue()

		XCTAssertEqual(snapshot.count, 1)
		XCTAssertEqual(snapshot.first?.resource, .media(type: .tracks, resourceId: "track-1"))
		XCTAssertEqual(snapshot.first?.parentCollection, .collection(type: .albums, resourceId: "stub-album"))
		XCTAssertEqual(snapshot.first?.state, .failed(action: .download))
	}

	func testSuccessfulDownloadDisappearsFromQueue() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-1"))

		await offliner.run()
		await backend.waitForTasksToComplete()

		let snapshot = try await offliner.getOfflineDownloadQueue()
		XCTAssertEqual(snapshot, [])
	}

	func testFailedEntryResourceCanBeUsedToRetry() async throws {
		let backend = FailOnceAddOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		await XCTAssertThrowsErrorAsync {
			try await offliner.download(collectionType: .playlists, resourceId: .identifier("playlist-1"))
		}
		let failedSnapshot = try await offliner.getOfflineDownloadQueue()
		let failed = try XCTUnwrap(failedSnapshot.first)

		try await retry(failed.resource, with: offliner)

		let retrySnapshot = try await offliner.getOfflineDownloadQueue()
		let retried = try XCTUnwrap(retrySnapshot.first)
		XCTAssertEqual(retried.resource, failed.resource)
		XCTAssertEqual(retried.state, .queued)
		let addCallCount = await backend.addCallCount
		XCTAssertEqual(addCallCount, 2)
	}

	private func collectUntilEmpty(
		_ iterator: inout AsyncThrowingStream<[OfflineDownloadQueueEntry], Error>.Iterator
	) async throws -> [[OfflineDownloadQueueEntry]] {
		var updates: [[OfflineDownloadQueueEntry]] = []
		while let snapshot = try await iterator.next() {
			updates.append(snapshot)
			if snapshot.isEmpty { return updates }
		}
		return updates
	}

	private func retry(_ resource: OfflineResource, with offliner: Offliner) async throws {
		switch resource {
		case .media(let type, let resourceId):
			try await offliner.download(mediaType: type, resourceId: .identifier(resourceId))
		case .collection(let type, let resourceId):
			try await offliner.download(collectionType: type, resourceId: .identifier(resourceId))
		}
	}

	private func storeAlbumTask(id: String) -> StoreAlbumTask {
		StoreAlbumTask(
			id: id,
			album: AlbumsResourceObject(id: "album-1", type: "albums"),
			artists: [],
			artwork: nil
		)
	}

	private func storeTrackTask(id: String, trackId: String, position: Int) -> StoreTrackTask {
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
}

private actor BlockingGetTasksOfflineApiClient: OfflineApiClientProtocol {
	private var requested = false
	private var requestedContinuation: CheckedContinuation<Void, Never>?
	private var responseContinuation: CheckedContinuation<(tasks: [OfflineTask], cursor: String?), Never>?

	func addItem(type: ResourceType, id: String) async throws {}
	func removeItem(type: ResourceType, id: String) async throws {}
	func updateTask(taskId: String, state: Download.State) async throws {}

	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) {
		requested = true
		requestedContinuation?.resume()
		requestedContinuation = nil
		return await withCheckedContinuation { responseContinuation = $0 }
	}

	func waitUntilRequested() async {
		if requested { return }
		await withCheckedContinuation { requestedContinuation = $0 }
	}

	func resume(with tasks: [OfflineTask]) {
		responseContinuation?.resume(returning: (tasks, nil))
		responseContinuation = nil
	}
}

private actor FailOnceAddOfflineApiClient: OfflineApiClientProtocol {
	private(set) var addCallCount = 0

	func addItem(type: ResourceType, id: String) async throws {
		addCallCount += 1
		if addCallCount == 1 { throw FakeError.backendFailed }
	}

	func removeItem(type: ResourceType, id: String) async throws {}
	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) { ([], nil) }
	func updateTask(taskId: String, state: Download.State) async throws {}
}

private func XCTAssertThrowsErrorAsync(
	_ expression: () async throws -> Void,
	file: StaticString = #filePath,
	line: UInt = #line
) async {
	do {
		try await expression()
		XCTFail("Expected error", file: file, line: line)
	} catch {
		// Expected.
	}
}
