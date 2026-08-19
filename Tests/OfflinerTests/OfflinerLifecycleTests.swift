@testable import Offliner
import XCTest

final class OfflinerLifecycleTests: OfflinerTestCase {
	func testBackgroundSessionEventHandlingReturnsDownloaderDecision() {
		let mediaDownloader = SucceedingMediaDownloader()
		mediaDownloader.handlesBackgroundSessionEvents = true
		let offliner = createOffliner(
			offlineApiClient: FailingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: mediaDownloader
		)

		let handled = offliner.handleBackgroundURLSessionEvents(identifier: "matching-session") {}

		XCTAssertTrue(handled)
		XCTAssertEqual(mediaDownloader.backgroundSessionIdentifiers, ["matching-session"])
	}

	func testBackgroundSessionEventHandlingRejectsResetInstance() async throws {
		let mediaDownloader = SucceedingMediaDownloader()
		mediaDownloader.handlesBackgroundSessionEvents = true
		let offliner = createOffliner(
			offlineApiClient: FailingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: mediaDownloader
		)
		try await offliner.reset()

		let handled = offliner.handleBackgroundURLSessionEvents(identifier: "matching-session") {}

		XCTAssertFalse(handled)
		XCTAssertTrue(mediaDownloader.backgroundSessionIdentifiers.isEmpty)
	}

	func testInstallationIdsHaveIsolatedCollectionsAndBackgroundSessions() async throws {
		let firstBackend = StubOfflineApiClient()
		let first = createOffliner(
			installationId: "installation-a",
			offlineApiClient: firstBackend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		try await first.download(collectionType: .albums, resourceId: .identifier("album-a"))
		await firstBackend.waitForTasksToComplete()

		let second = createOffliner(
			installationId: "installation-b",
			offlineApiClient: FailingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		let firstCollections = try await first.getStoredOfflineCollections(collectionType: .albums)
		let secondCollections = try await second.getStoredOfflineCollections(collectionType: .albums)
		XCTAssertEqual(firstCollections.count, 1)
		XCTAssertTrue(secondCollections.isEmpty)

		let firstStorage = try OfflinerStorage(installationId: "installation-a", baseDirectory: tempDir)
		let secondStorage = try OfflinerStorage(installationId: "installation-b", baseDirectory: tempDir)
		XCTAssertNotEqual(firstStorage.rootDirectory, secondStorage.rootDirectory)
		XCTAssertNotEqual(firstStorage.backgroundSessionIdentifier, secondStorage.backgroundSessionIdentifier)
		XCTAssertLessThanOrEqual(firstStorage.backgroundSessionIdentifier.count, 64)
	}

	func testResetIsLocalOnlyRemovesArtifactsAndPermanentlyInvalidatesInstance() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			installationId: "installation-a",
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-a"))
		await backend.waitForTasksToComplete()
		let playbackAsset = await offliner.getOfflinePlaybackAsset(mediaType: .tracks, resourceId: .identifier("track-a"))
		let asset = try XCTUnwrap(playbackAsset)
		XCTAssertTrue(FileManager.default.fileExists(atPath: asset.mediaURL.path))
		let removedItemCount = backend.removedItems.count

		try await offliner.reset()

		XCTAssertFalse(FileManager.default.fileExists(atPath: asset.mediaURL.path))
		XCTAssertEqual(backend.removedItems.count, removedItemCount)
		do {
			_ = try await offliner.getStoredOfflineCollections(collectionType: .albums)
			XCTFail("Expected reset instance to reject reads")
		} catch OfflinerLifecycleError.reset {}

		let replacement = createOffliner(
			installationId: "installation-a",
			offlineApiClient: FailingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		let collections = try await replacement.getStoredOfflineCollections(collectionType: .albums)
		let mediaItem = try await replacement.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-a"))
		XCTAssertTrue(collections.isEmpty)
		XCTAssertNil(mediaItem)
	}

	func testStaleInFlightDownloadCannotRepopulateAfterResetStarts() async throws {
		let backend = StubOfflineApiClient()
		let mediaDownloader = SuspendingMediaDownloader(resumesOnCancel: false)
		let offliner = createOffliner(
			installationId: "installation-a",
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: mediaDownloader
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-a"))
		await mediaDownloader.waitUntilStarted()
		let reset = Task { try await offliner.reset() }
		await mediaDownloader.waitUntilCancelled()
		await mediaDownloader.complete()
		try await reset.value

		let replacement = createOffliner(
			installationId: "installation-a",
			offlineApiClient: FailingOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		let mediaItem = try await replacement.getOfflineMediaItem(mediaType: .tracks, resourceId: .identifier("track-a"))
		XCTAssertNil(mediaItem)
	}
}
