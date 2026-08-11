import GRDB
@testable import Offliner
import TidalAPI
import XCTest

// MARK: - ResourceStateTests

final class ResourceStateTests: OfflinerTestCase {
	func testRegistrationFailurePreservesDownloadRetryDirection() async throws {
		let offliner = createOffliner(
			offlineApiClient: FailingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		let resource = OfflineResource.media(type: .tracks, resourceId: "track-1")

		await XCTAssertThrowsErrorAsync {
			try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-1"))
		}

		let state = try await offliner.getOfflineResourceState(for: resource)
		XCTAssertEqual(state, .failed(action: .download))
	}

	func testLegacyCollectionStateMapsFailedDownloadToNotDownloaded() async throws {
		let offliner = createOffliner(
			offlineApiClient: FailingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		await XCTAssertThrowsErrorAsync {
			try await offliner.download(collectionType: .albums, resourceId: .identifier("album-1"))
		}

		let state = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-1")
		).first()
		XCTAssertEqual(state, .notDownloaded)
	}

	func testLegacyCollectionStateMapsFailedRemoveToDownloaded() async throws {
		let storage = try OfflinerStorage(installationId: "failed-remove", baseDirectory: tempDir)
		try storage.offlineStore.storeCollection(StoreCollectionTaskResult(
			resourceType: .albums,
			resourceId: "album-1",
			catalogMetadata: .album(.mock(id: "album-1")),
			artworkURL: nil
		))
		let offliner = Offliner(
			storage: storage,
			offlineApiClient: FailingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader(),
			trackManifestFetcher: SucceedingTrackManifestFetcher(),
			videoManifestFetcher: SucceedingVideoManifestFetcher()
		)
		await XCTAssertThrowsErrorAsync {
			try await offliner.remove(collectionType: .albums, resourceId: .identifier("album-1"))
		}
		let exactState = try await offliner.getOfflineResourceState(
			for: .collection(type: .albums, resourceId: "album-1")
		)
		XCTAssertEqual(exactState, .failed(action: .remove))

		let state = await offliner.getOfflineCollectionDownloadState(
			collectionType: .albums,
			resourceId: .identifier("album-1")
		).first()
		XCTAssertEqual(state, .downloaded)
	}

	func testRepeatedDownloadWhileQueuedRegistersOnlyOnce() async throws {
		let backend = HoldingOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-1"))
		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-1"))

		XCTAssertEqual(backend.addedItems.count, 1)
		let state = try await offliner.getOfflineResourceState(for: .media(type: .tracks, resourceId: "track-1"))
		XCTAssertEqual(state, .queued)
	}

	func testRepeatedRemoveWhileRemovingRegistersOnlyOnce() async throws {
		let backend = HoldingOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.remove(mediaType: .videos, resourceId: .identifier("video-1"))
		try await offliner.remove(mediaType: .videos, resourceId: .identifier("video-1"))

		XCTAssertEqual(backend.removedItems.count, 1)
		let state = try await offliner.getOfflineResourceState(for: .media(type: .videos, resourceId: "video-1"))
		XCTAssertEqual(state, .removing)
	}

	func testOppositeOperationsAreRejectedInBothDirections() async throws {
		let backend = HoldingOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-1"))
		do {
			try await offliner.remove(mediaType: .tracks, resourceId: .identifier("track-1"))
			XCTFail("Expected the queued download to reject removal")
		} catch let error as OfflineResourceOperationError {
			XCTAssertEqual(error, .conflictingOperationInProgress(currentState: .queued))
		}

		try await offliner.remove(mediaType: .videos, resourceId: .identifier("video-1"))
		do {
			try await offliner.download(mediaType: .videos, resourceId: .identifier("video-1"))
			XCTFail("Expected the active removal to reject download")
		} catch let error as OfflineResourceOperationError {
			XCTAssertEqual(error, .conflictingOperationInProgress(currentState: .removing))
		}

		XCTAssertTrue(backend.removedItems.allSatisfy { $0.id != "track-1" })
		XCTAssertTrue(backend.addedItems.allSatisfy { $0.id != "video-1" })
	}

	func testQueuedStateRecoversOfflineAfterOfflinerRecreation() async throws {
		let installationId = "relaunch-installation"
		let firstBackend = HoldingOfflineApiClient()
		let first = createOffliner(
			installationId: installationId,
			offlineApiClient: firstBackend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		try await first.download(collectionType: .albums, resourceId: .identifier("album-1"))
		let persistedState = try await lastDatabaseQueue.read { database in
			try String.fetchOne(database, sql: "SELECT state FROM offline_resource_operation WHERE resource_id = 'album-1'")
		}
		XCTAssertEqual(persistedState, "queued")

		let second = createOffliner(
			installationId: installationId,
			offlineApiClient: FailOnGetTasksOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let state = try await second.getOfflineResourceState(for: .collection(type: .albums, resourceId: "album-1"))
		XCTAssertEqual(state, .queued)
	}

	func testFailedBackendTaskRecoversOnNewOfflinerInstance() async throws {
		let backend = StubOfflineApiClient()
		backend.enqueueTasks([.storeAlbum(StoreAlbumTask(
			id: "failed-album",
			state: .failed,
			album: AlbumsResourceObject(id: "album-1", type: "albums"),
			artists: [],
			artwork: nil
		))])
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		await offliner.run()
		let state = try await offliner.getOfflineResourceState(
			for: .collection(type: .albums, resourceId: "album-1")
		)
		XCTAssertEqual(state, .failed(action: .download))
	}

	func testExplicitRetrySupersedesFailureGeneration() async throws {
		let storage = try OfflinerStorage(installationId: "retry-state", baseDirectory: tempDir)
		let tracker = ResourceStateTracker(offlineStore: storage.offlineStore)
		let resource = OfflineResourceKey(.media(type: .tracks, resourceId: "track-1"))
		_ = try await tracker.begin(.store, for: resource)
		await tracker.registrationFailed(.store, for: resource)

		let retried = try await tracker.begin(.store, for: resource)
		let state = try await tracker.state(for: resource)

		XCTAssertTrue(retried)
		XCTAssertEqual(state, .queued)
	}

	func testResourceStateStreamFinishesOnReset() async throws {
		let offliner = createOffliner(
			offlineApiClient: HoldingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		let stream = offliner.observeOfflineResourceState(for: .media(type: .tracks, resourceId: "track-1"))
		var iterator = stream.makeAsyncIterator()
		let initialState = await iterator.next()
		XCTAssertEqual(initialState, .notDownloaded)

		try await offliner.reset()

		let finalState = await iterator.next()
		XCTAssertNil(finalState)
	}

	func testCollectionStorePublishesDownloadingRatherThanRemoving() async throws {
		let backend = StubOfflineApiClient()
		let artwork = SuspendingArtworkDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: artwork,
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-1"))
		await artwork.waitUntilStarted()

		let state = try await offliner.getOfflineResourceState(for: .collection(type: .albums, resourceId: "album-1"))
		XCTAssertEqual(state, .downloading)
		await artwork.complete()
		await backend.waitForTasksToComplete()
	}

	func testMediaStateTransitionsToDownloadedAndExposesCorrelation() async throws {
		let backend = StubOfflineApiClient()
		let media = SuspendingMediaDownloader()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)
		let downloads = offliner.newDownloads

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-1"))
		var iterator = downloads.makeAsyncIterator()
		let download = await iterator.next()
		await media.waitUntilStarted()

		XCTAssertEqual(download?.taskId, "task-0")
		XCTAssertEqual(download?.resource, .media(type: .tracks, resourceId: "track-1"))
		let state = try await offliner.getOfflineResourceState(for: .media(type: .tracks, resourceId: "track-1"))
		XCTAssertEqual(state, .downloading)

		await media.complete()
		await backend.waitForTasksToComplete()
		await assertEventuallyResourceState(
			offliner,
			resource: .media(type: .tracks, resourceId: "track-1"),
			expected: .downloaded
		)
	}

	func testCollectionFailureSurvivesLaterSiblingSuccess() async throws {
		let installationId = "sibling-failure"
		let backend = StubOfflineApiClient()
		let media = SelectiveSuspendingMediaDownloader(failingTaskIds: ["failing-track"])
		let offliner = createOffliner(
			installationId: installationId,
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: media
		)
		backend.enqueueTasks([
			.storeTrack(storeTrackTask(id: "failing-track", trackId: "track-1", position: 1)),
			.storeTrack(storeTrackTask(id: "succeeding-track", trackId: "track-2", position: 2)),
		])

		await offliner.run()
		await media.waitUntilStarted(count: 2)
		await assertEventuallyResourceState(
			offliner,
			resource: .collection(type: .albums, resourceId: "album-1"),
			expected: .failed(action: .download)
		)

		await media.complete(taskId: "succeeding-track")
		await backend.waitForTasksToComplete()
		let finalState = try await offliner.getOfflineResourceState(
			for: .collection(type: .albums, resourceId: "album-1")
		)
		XCTAssertEqual(finalState, .failed(action: .download))
		let persistedState = try await lastDatabaseQueue.read { database in
			try String.fetchOne(database, sql: "SELECT state FROM offline_resource_operation WHERE resource_id = 'album-1'")
		}
		XCTAssertEqual(persistedState, "failed_download")

		let recreated = createOffliner(
			installationId: installationId,
			offlineApiClient: FailOnGetTasksOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		let recoveredState = try await recreated.getOfflineResourceState(
			for: .collection(type: .albums, resourceId: "album-1")
		)
		XCTAssertEqual(recoveredState, .failed(action: .download))
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

	private func assertEventuallyResourceState(
		_ offliner: Offliner,
		resource: OfflineResource,
		expected: OfflineResourceState,
		file: StaticString = #filePath,
		line: UInt = #line
	) async {
		for _ in 0 ..< 100 {
			if let state = try? await offliner.getOfflineResourceState(for: resource), state == expected {
				return
			}
			try? await Task.sleep(nanoseconds: 10_000_000)
		}
		XCTFail("Timed out waiting for \(expected)", file: file, line: line)
	}
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
