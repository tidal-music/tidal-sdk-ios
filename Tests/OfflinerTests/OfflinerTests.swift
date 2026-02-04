@testable import Offliner
import Auth
import AVFoundation
import GRDB
import TidalAPI
import XCTest

// MARK: - OfflinerTests

final class OfflinerTests: XCTestCase {
	private var tempDir: URL!

	override func setUp() {
		super.setUp()
		tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try? FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
	}

	override func tearDown() {
		if let tempDir {
			try? FileManager.default.removeItem(at: tempDir)
		}
		super.tearDown()
	}

	// MARK: - Track Download Tests

	func testDownloadTrackCreatesDownload() async throws {
		let offliner = createOffliner(
			backendRepository: StubBackendRepository(),
			artworkDownloader: SucceedingArtworkRepository(),
			mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")
		try await offliner.run()

		let downloads = await offliner.currentDownloads
		XCTAssertEqual(downloads.count, 1)
	}

	func testDownloadTrackCompletesSuccessfully() async throws {
		let offliner = createOffliner(
			backendRepository: StubBackendRepository(),
			artworkDownloader: SucceedingArtworkRepository(),
			mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			await assertEventually(events) { event in
				if case .state(.completed) = event { return true }
				return false
			}
			break
		}

		try await runTask
	}

	func testDownloadTrackStoresInLocalDatabase() async throws {
		let offliner = createOffliner(
			backendRepository: StubBackendRepository(),
			artworkDownloader: SucceedingArtworkRepository(),
			mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			await assertEventually(events) { event in
				if case .state(.completed) = event { return true }
				return false
			}
			break
		}

		try await runTask

		let storedItem = try offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		XCTAssertNotNil(storedItem)
		XCTAssertEqual(storedItem?.id, "task-0")

		if case .track(let metadata) = storedItem?.metadata {
			XCTAssertEqual(metadata.track.id, "track-123")
		} else {
			XCTFail("Expected track metadata")
		}
	}

	func testRedownloadTrackDeletesOldFilesAndStoresNewOnes() async throws {
		let backend = StubBackendRepository()
		let artworkDownloader = SucceedingArtworkRepository()
		let mediaDownloader = SucceedingMediaDownloader()
		let offliner = createOffliner(
			backendRepository: backend,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader)

		// First download
		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		do {
			let downloads = offliner.newDownloads
			async let runTask: () = offliner.run()

			for await download in downloads {
				let events = download.events
				await assertEventually(events) { event in
					if case .state(.completed) = event { return true }
					return false
				}
				break
			}

			try await runTask
		}

		let firstItem = try XCTUnwrap(offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123"))
		let firstMediaURL = firstItem.mediaURL
		let firstArtworkURL = try XCTUnwrap(firstItem.artworkURL)
		XCTAssertTrue(FileManager.default.fileExists(atPath: firstMediaURL.path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: firstArtworkURL.path))

		// Second download of the same track
		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		do {
			let downloads = offliner.newDownloads
			async let runTask: () = offliner.run()

			for await download in downloads {
				let events = download.events
				await assertEventually(events) { event in
					if case .state(.completed) = event { return true }
					return false
				}
				break
			}

			try await runTask
		}

		let secondItem = try XCTUnwrap(offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123"))
		let secondMediaURL = secondItem.mediaURL
		let secondArtworkURL = try XCTUnwrap(secondItem.artworkURL)

		// Old files should be deleted
		XCTAssertFalse(FileManager.default.fileExists(atPath: firstMediaURL.path))
		XCTAssertFalse(FileManager.default.fileExists(atPath: firstArtworkURL.path))

		XCTAssertTrue(FileManager.default.fileExists(atPath: secondMediaURL.path))
		XCTAssertTrue(FileManager.default.fileExists(atPath: secondArtworkURL.path))

		// URLs should be different
		XCTAssertNotEqual(firstMediaURL, secondMediaURL)
		XCTAssertNotEqual(firstArtworkURL, secondArtworkURL)
	}

	func testDownloadTrackFailsWhenMediaDownloadFails() async throws {
		let offliner = createOffliner(
			backendRepository: StubBackendRepository(),
			artworkDownloader: SucceedingArtworkRepository(),
			mediaDownloader: FailingMediaDownloader())

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			await assertEventually(events) { event in
				if case .state(.failed) = event { return true }
				return false
			}
			break
		}

		try await runTask
	}

	func testFailedDownloadDoesNotStoreInLocalDatabase() async throws {
		let offliner = createOffliner(
			backendRepository: StubBackendRepository(),
			artworkDownloader: SucceedingArtworkRepository(),
			mediaDownloader: FailingMediaDownloader())

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			await assertEventually(events) { event in
				if case .state(.failed) = event { return true }
				return false
			}
			break
		}

		try await runTask

		let storedItem = try offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		XCTAssertNil(storedItem)
	}

	func testDownloadMultipleTracksStoresAllInLocalDatabase() async throws {
		let offliner = createOffliner(
			backendRepository: StubBackendRepository(),
			artworkDownloader: SucceedingArtworkRepository(),
			mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(mediaType: .tracks, resourceId: "track-1")
		try await offliner.download(mediaType: .tracks, resourceId: "track-2")
		try await offliner.download(mediaType: .tracks, resourceId: "track-3")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		var downloadsList: [Download] = []
		for await download in downloads {
			downloadsList.append(download)
			if downloadsList.count == 3 { break }
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

		try await runTask

		let storedItems = try offliner.getOfflineMediaItems(mediaType: .tracks)
		XCTAssertEqual(storedItems.count, 3)

		let resourceIds = storedItems.compactMap { item -> String? in
			if case .track(let metadata) = item.metadata {
				return metadata.track.id
			}
			return nil
		}
		XCTAssertTrue(resourceIds.contains("track-1"))
		XCTAssertTrue(resourceIds.contains("track-2"))
		XCTAssertTrue(resourceIds.contains("track-3"))
	}

	func testDownloadTrackReportsProgress() async throws {
		let media = SucceedingMediaDownloader()
		media.progressValues = [0.25, 0.5, 0.75]

		let offliner = createOffliner(
			backendRepository: StubBackendRepository(),
			artworkDownloader: SucceedingArtworkRepository(),
			mediaDownloader: media)

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			var progressValues: [Double] = []
			for await event in events {
				if case .progress(let value) = event {
					progressValues.append(value)
				}
				if case .state(.completed) = event {
					break
				}
			}
			XCTAssertEqual(progressValues, [0.25, 0.5, 0.75])
			break
		}

		try await runTask
	}

	func testDownloadTrackFailsWhenArtworkDownloadFails() async throws {
		let offliner = createOffliner(
			backendRepository: StubBackendRepository(),
			artworkDownloader: FailingArtworkRepository(),
			mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			await assertEventually(events) { event in
				if case .state(.failed) = event { return true }
				return false
			}
			break
		}

		try await runTask
	}

	// MARK: - Video Download Tests

	func testDownloadVideoStoresInLocalDatabase() async throws {
		let offliner = createOffliner(
			backendRepository: StubBackendRepository(),
			artworkDownloader: SucceedingArtworkRepository(),
			mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(mediaType: .videos, resourceId: "video-456")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			await assertEventually(events) { event in
				if case .state(.completed) = event { return true }
				return false
			}
			break
		}

		try await runTask

		let storedItem = try offliner.getOfflineMediaItem(mediaType: .videos, resourceId: "video-456")
		XCTAssertNotNil(storedItem)

		if case .video(let metadata) = storedItem?.metadata {
			XCTAssertEqual(metadata.video.id, "video-456")
		} else {
			XCTFail("Expected video metadata")
		}
	}

	// MARK: - Album Download Tests

	func testDownloadAlbumDoesNotCreateDownloadObject() async throws {
		let offliner = createOffliner(
			backendRepository: StubBackendRepository(),
			artworkDownloader: SucceedingArtworkRepository(),
			mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()

		let downloads = await offliner.currentDownloads
		XCTAssertEqual(downloads.count, 0)
	}

	func testDownloadAlbumStoresInLocalDatabase() async throws {
		let backend = StubBackendRepository()
		let offliner = createOffliner(
			backendRepository: backend,
			artworkDownloader: SucceedingArtworkRepository(),
			mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try offliner.getOfflineCollection(collectionType: .albums, resourceId: "album-123")
		XCTAssertNotNil(storedCollection)

		if case .album(let metadata) = storedCollection?.metadata {
			XCTAssertEqual(metadata.album.id, "album-123")
		} else {
			XCTFail("Expected album metadata")
		}
	}

	func testRedownloadAlbumDeletesOldArtworkAndStoresNewOne() async throws {
		let backend = StubBackendRepository()
		let offliner = createOffliner(
			backendRepository: backend,
			artworkDownloader: SucceedingArtworkRepository(),
			mediaDownloader: SucceedingMediaDownloader())

		// First download
		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let firstCollection = try XCTUnwrap(offliner.getOfflineCollection(collectionType: .albums, resourceId: "album-123"))
		let firstArtworkURL = try XCTUnwrap(firstCollection.artworkURL)
		XCTAssertTrue(FileManager.default.fileExists(atPath: firstArtworkURL.path))

		// Second download of the same album
		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let secondCollection = try XCTUnwrap(offliner.getOfflineCollection(collectionType: .albums, resourceId: "album-123"))
		let secondArtworkURL = try XCTUnwrap(secondCollection.artworkURL)

		// Old artwork should be deleted
		XCTAssertFalse(FileManager.default.fileExists(atPath: firstArtworkURL.path))

		XCTAssertTrue(FileManager.default.fileExists(atPath: secondArtworkURL.path))

		// URLs should be different
		XCTAssertNotEqual(firstArtworkURL, secondArtworkURL)
	}

	func testDownloadAlbumFailsWhenArtworkDownloadFails() async throws {
		let backend = StubBackendRepository()
		let offliner = createOffliner(
			backendRepository: backend,
			artworkDownloader: FailingArtworkRepository(),
			mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try offliner.getOfflineCollection(collectionType: .albums, resourceId: "album-123")
		XCTAssertNil(storedCollection)
	}

	// MARK: - Backend Failure Tests

	func testDownloadTrackAbortsWhenUpdateTaskToInProgressFails() async throws {
		let backend = FailOnUpdateToInProgressBackendRepository()
		let offliner = createOffliner(backendRepository: backend, artworkDownloader: SucceedingArtworkRepository(), mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let state = await download.state
			// Download should remain in pending state since updateTask to inProgress failed
			XCTAssertEqual(state, .pending)
			break
		}

		try await runTask

		// Item should not be stored since download was aborted
		let storedItem = try offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		XCTAssertNil(storedItem)
	}

	func testDownloadTrackFailsWhenUpdateTaskToCompletedFails() async throws {
		let backend = FailOnUpdateToCompletedBackendRepository()
		let offliner = createOffliner(backendRepository: backend, artworkDownloader: SucceedingArtworkRepository(), mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")

		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			await assertEventually(events) { event in
				// Download reports failure when backend update to completed fails
				if case .state(.failed) = event { return true }
				return false
			}
			break
		}

		try await runTask

		// Item is stored locally even though download is marked as failed
		// (the media was downloaded successfully, only the backend update failed)
		let storedItem = try offliner.getOfflineMediaItem(mediaType: .tracks, resourceId: "track-123")
		XCTAssertNotNil(storedItem)
	}

	func testDownloadTrackFailsWhenAddItemFails() async throws {
		let offliner = createOffliner(backendRepository: FailingBackendRepository(), artworkDownloader: SucceedingArtworkRepository(), mediaDownloader: SucceedingMediaDownloader())

		do {
			try await offliner.download(mediaType: .tracks, resourceId: "track-123")
			XCTFail("Expected download to throw when addItem fails")
		} catch {
			// Expected - addItem failure should propagate
		}

		let downloads = await offliner.currentDownloads
		XCTAssertEqual(downloads.count, 0)
	}

	func testDownloadAlbumFailsWhenAddItemFails() async throws {
		let offliner = createOffliner(backendRepository: FailingBackendRepository(), artworkDownloader: SucceedingArtworkRepository(), mediaDownloader: SucceedingMediaDownloader())

		do {
			try await offliner.download(collectionType: .albums, resourceId: "album-123")
			XCTFail("Expected download to throw when addItem fails")
		} catch {
			// Expected - addItem failure should propagate
		}
	}

	func testGetTasksFailurePropagates() async throws {
		let backend = FailOnGetTasksBackendRepository()
		let offliner = createOffliner(backendRepository: backend, artworkDownloader: SucceedingArtworkRepository(), mediaDownloader: SucceedingMediaDownloader())

		do {
			try await offliner.run()
			XCTFail("Expected run to throw when getTasks fails")
		} catch {
			// Expected - getTasks failure propagates from run()
		}
	}

	// MARK: - Playlist Download Tests

	func testDownloadPlaylistStoresInLocalDatabase() async throws {
		let backend = StubBackendRepository()
		let offliner = createOffliner(
			backendRepository: backend,
			artworkDownloader: SucceedingArtworkRepository(),
			mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(collectionType: .playlists, resourceId: "playlist-456")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try offliner.getOfflineCollection(collectionType: .playlists, resourceId: "playlist-456")
		XCTAssertNotNil(storedCollection)

		if case .playlist(let metadata) = storedCollection?.metadata {
			XCTAssertEqual(metadata.playlist.id, "playlist-456")
		} else {
			XCTFail("Expected playlist metadata")
		}
	}

	func testDownloadPlaylistFailsWhenArtworkDownloadFails() async throws {
		let backend = StubBackendRepository()
		let offliner = createOffliner(
			backendRepository: backend,
			artworkDownloader: FailingArtworkRepository(),
			mediaDownloader: SucceedingMediaDownloader())

		try await offliner.download(collectionType: .playlists, resourceId: "playlist-456")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try offliner.getOfflineCollection(collectionType: .playlists, resourceId: "playlist-456")
		XCTAssertNil(storedCollection)
	}

	// MARK: - Helpers

	private func createOffliner(
		backendRepository: BackendRepositoryProtocol,
		artworkDownloader: ArtworkRepositoryProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) -> Offliner {
		let dbPath = tempDir.appendingPathComponent("test-\(UUID().uuidString).sqlite").path
		let databaseQueue = try! DatabaseQueue(path: dbPath)
		try! Migrations.run(databaseQueue)
		let localRepository = LocalRepository(databaseQueue)

		return Offliner(
			backendRepository: backendRepository,
			localRepository: localRepository,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader
		)
	}
}

// MARK: - Fakes

final class StubBackendRepository: BackendRepositoryProtocol {
	private(set) var tasks: [OfflineTask] = []
	private var taskIdCounter = 0

	func addItem(type: ResourceType, id: String) async throws {
		let taskId = "task-\(taskIdCounter)"
		let index = taskIdCounter + 1
		taskIdCounter += 1

		switch type {
		case .track:
			let track = TracksResourceObject(id: id, type: "tracks")
			let metadata = OfflineMediaItem.TrackMetadata(track: track, artists: [], coverArt: nil)
			let task = StoreItemTask(id: taskId, metadata: .track(metadata), collectionId: "collection-1", volume: 1, index: index)
			tasks.append(.storeItem(task))

		case .video:
			let video = VideosResourceObject(id: id, type: "videos")
			let metadata = OfflineMediaItem.VideoMetadata(video: video, artists: [], thumbnail: nil)
			let task = StoreItemTask(id: taskId, metadata: .video(metadata), collectionId: "collection-1", volume: 1, index: index)
			tasks.append(.storeItem(task))

		case .album:
			let album = AlbumsResourceObject(id: id, type: "albums")
			let metadata = OfflineCollection.AlbumMetadata(album: album, artists: [], coverArt: nil)
			let task = StoreCollectionTask(id: taskId, metadata: .album(metadata))
			tasks.append(.storeCollection(task))

		case .playlist:
			let playlist = PlaylistsResourceObject(id: id, type: "playlists")
			let metadata = OfflineCollection.PlaylistMetadata(playlist: playlist, coverArt: nil)
			let task = StoreCollectionTask(id: taskId, metadata: .playlist(metadata))
			tasks.append(.storeCollection(task))

		case .userCollection:
			break
		}
	}

	func removeItem(type: ResourceType, id: String) async throws {
		let taskId = "task-\(taskIdCounter)"
		taskIdCounter += 1

		switch type {
		case .track:
			let track = TracksResourceObject(id: id, type: "tracks")
			let metadata = OfflineMediaItem.TrackMetadata(track: track, artists: [], coverArt: nil)
			let task = RemoveItemTask(id: taskId, metadata: .track(metadata))
			tasks.append(.removeItem(task))

		case .video:
			let video = VideosResourceObject(id: id, type: "videos")
			let metadata = OfflineMediaItem.VideoMetadata(video: video, artists: [], thumbnail: nil)
			let task = RemoveItemTask(id: taskId, metadata: .video(metadata))
			tasks.append(.removeItem(task))

		case .album:
			let album = AlbumsResourceObject(id: id, type: "albums")
			let metadata = OfflineCollection.AlbumMetadata(album: album, artists: [], coverArt: nil)
			let task = RemoveCollectionTask(id: taskId, metadata: .album(metadata))
			tasks.append(.removeCollection(task))

		case .playlist:
			let playlist = PlaylistsResourceObject(id: id, type: "playlists")
			let metadata = OfflineCollection.PlaylistMetadata(playlist: playlist, coverArt: nil)
			let task = RemoveCollectionTask(id: taskId, metadata: .playlist(metadata))
			tasks.append(.removeCollection(task))

		case .userCollection:
			break
		}
	}

	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) {
		(tasks, nil)
	}

	func updateTask(taskId: String, state: Download.State) async throws {
		if state == .completed || state == .failed {
			tasks.removeAll { $0.id == taskId }
		}
	}

	func waitForTasksToComplete() async {
		while !tasks.isEmpty {
			try? await Task.sleep(nanoseconds: 10_000_000)
		}
	}
}

final class FailingBackendRepository: BackendRepositoryProtocol {
	func addItem(type: ResourceType, id: String) async throws {
		throw FakeError.backendFailed
	}

	func removeItem(type: ResourceType, id: String) async throws {
		throw FakeError.backendFailed
	}

	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) {
		throw FakeError.backendFailed
	}

	func updateTask(taskId: String, state: Download.State) async throws {
		throw FakeError.backendFailed
	}
}

final class FailOnUpdateToInProgressBackendRepository: BackendRepositoryProtocol {
	private let stub = StubBackendRepository()

	func addItem(type: ResourceType, id: String) async throws {
		try await stub.addItem(type: type, id: id)
	}

	func removeItem(type: ResourceType, id: String) async throws {
		try await stub.removeItem(type: type, id: id)
	}

	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) {
		try await stub.getTasks(cursor: cursor)
	}

	func updateTask(taskId: String, state: Download.State) async throws {
		if state == .inProgress {
			throw FakeError.backendFailed
		}
		try await stub.updateTask(taskId: taskId, state: state)
	}
}

final class FailOnUpdateToCompletedBackendRepository: BackendRepositoryProtocol {
	private let stub = StubBackendRepository()

	func addItem(type: ResourceType, id: String) async throws {
		try await stub.addItem(type: type, id: id)
	}

	func removeItem(type: ResourceType, id: String) async throws {
		try await stub.removeItem(type: type, id: id)
	}

	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) {
		try await stub.getTasks(cursor: cursor)
	}

	func updateTask(taskId: String, state: Download.State) async throws {
		if state == .completed {
			throw FakeError.backendFailed
		}
		try await stub.updateTask(taskId: taskId, state: state)
	}
}

final class FailOnGetTasksBackendRepository: BackendRepositoryProtocol {
	func addItem(type: ResourceType, id: String) async throws {}

	func removeItem(type: ResourceType, id: String) async throws {}

	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) {
		throw FakeError.backendFailed
	}

	func updateTask(taskId: String, state: Download.State) async throws {}
}

final class SucceedingArtworkRepository: ArtworkRepositoryProtocol {
	func downloadArtwork(for task: StoreItemTask) async throws -> URL {
		createArtworkFile()
	}

	func downloadArtwork(for task: StoreCollectionTask) async throws -> URL {
		createArtworkFile()
	}

	private func createArtworkFile() -> URL {
		let tempDir = FileManager.default.temporaryDirectory
		let url = tempDir.appendingPathComponent("artwork-\(UUID().uuidString).jpg")
		try? Data("artwork".utf8).write(to: url)
		return url
	}
}

final class FailingArtworkRepository: ArtworkRepositoryProtocol {
	func downloadArtwork(for task: StoreItemTask) async throws -> URL {
		throw FakeError.artworkDownloadFailed
	}

	func downloadArtwork(for task: StoreCollectionTask) async throws -> URL {
		throw FakeError.artworkDownloadFailed
	}
}

final class SucceedingMediaDownloader: MediaDownloaderProtocol {
	var progressValues: [Double] = []

	func download(
		manifestURL: URL,
		taskId: String,
		onProgress: @escaping (Double) -> Void
	) async throws -> MediaDownloadResult {
		for progress in progressValues {
			onProgress(progress)
		}

		let tempDir = FileManager.default.temporaryDirectory
		let url = tempDir.appendingPathComponent("media-\(UUID().uuidString).m4a")
		try? Data("media".utf8).write(to: url)

		return MediaDownloadResult(
			mediaURL: url,
			licenseURL: nil
		)
	}
}

final class FailingMediaDownloader: MediaDownloaderProtocol {
	func download(
		manifestURL: URL,
		taskId: String,
		onProgress: @escaping (Double) -> Void
	) async throws -> MediaDownloadResult {
		throw FakeError.downloadFailed
	}
}

enum FakeError: Error {
	case backendFailed
	case artworkDownloadFailed
	case downloadFailed
}

// MARK: - Test Helpers

func assertEventually(
	_ stream: AsyncStream<Download.Event>,
	condition: @escaping (Download.Event) -> Bool
) async {
	for await element in stream {
		if condition(element) {
			return
		}
	}
	XCTFail("Stream ended without matching condition")
}
