@testable import Offliner
import XCTest

final class OfflinerLifecycleTests: OfflinerTestCase {
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

	func testLegacyStorageMigratesToFirstInstallation() async throws {
		let legacyRoot = tempDir.appendingPathComponent("Offliner", isDirectory: true)
		try FileManager.default.createDirectory(at: legacyRoot, withIntermediateDirectories: true)
		let legacyArtworkDirectory = legacyRoot.appendingPathComponent("Artworks", isDirectory: true)
		try FileManager.default.createDirectory(at: legacyArtworkDirectory, withIntermediateDirectories: true)
		let artworkURL = legacyArtworkDirectory.appendingPathComponent("album.jpg")
		try Data("artwork".utf8).write(to: artworkURL)
		let legacyLicenseDirectory = legacyRoot.appendingPathComponent("Licenses", isDirectory: true)
		try FileManager.default.createDirectory(at: legacyLicenseDirectory, withIntermediateDirectories: true)
		let licenseURL = legacyLicenseDirectory.appendingPathComponent("track.key")
		try Data("license".utf8).write(to: licenseURL)
		let mediaURL = tempDir.appendingPathComponent("track.movpkg")
		try Data("media".utf8).write(to: mediaURL)

		let legacyDatabase = try OfflineStore.makeDatabaseQueue(path: legacyRoot.appendingPathComponent("offline.sqlite").path)
		try Migrations.run(legacyDatabase)
		let legacyStore = OfflineStore(legacyDatabase)
		try legacyStore.storeCollection(StoreCollectionTaskResult(
			resourceType: .albums,
			resourceId: "album-a",
			catalogMetadata: .album(.mock(id: "album-a")),
			artworkURL: artworkURL
		))
		try legacyStore.storeMediaItem(StoreItemTaskResult(
			resourceType: OfflineMediaItemType.tracks.rawValue,
			resourceId: "track-a",
			catalogMetadata: .track(.mock(id: "track-a")),
			playbackMetadata: .mock(),
			collectionResourceType: OfflineCollectionType.albums.rawValue,
			collectionResourceId: "album-a",
			volume: 1,
			position: 1,
			addedAt: nil,
			mediaURL: mediaURL,
			licenseURL: licenseURL,
			artworkURL: artworkURL
		))
		try legacyDatabase.close()

		let storage = try OfflinerStorage(installationId: "installation-a", baseDirectory: tempDir)
		let collections = try await storage.offlineStore.getCollections(collectionType: .albums)
		let migratedCollection = try XCTUnwrap(collections.first)
		let migratedArtworkURL = try XCTUnwrap(migratedCollection.artworkURL)
		let storedPlaybackAsset = try await storage.offlineStore.getPlaybackAsset(mediaType: .tracks, resourceId: "track-a")
		let playbackAsset = try XCTUnwrap(storedPlaybackAsset)
		let migratedLicenseURL = try XCTUnwrap(playbackAsset.licenseURL)

		XCTAssertEqual(collections.map(\.catalogMetadata.id), ["album-a"])
		XCTAssertTrue(FileManager.default.fileExists(atPath: migratedArtworkURL.path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: playbackAsset.mediaURL.path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: migratedLicenseURL.path))
		XCTAssertFalse(FileManager.default.fileExists(atPath: legacyRoot.appendingPathComponent("offline.sqlite").path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: storage.rootDirectory.appendingPathComponent("offline.sqlite").path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: storage.rootDirectory
			.appendingPathComponent("Artifacts/Artworks/album.jpg").path))
	}
}
