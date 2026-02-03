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
		let backend = StubBackendRepository()
		let offliner = createOffliner(backendRepository: backend)

		try await offliner.download(mediaType: .tracks, resourceId: "track-123")
		try await offliner.run()

		let downloads = await offliner.currentDownloads
		XCTAssertEqual(downloads.count, 1)
	}

	func testDownloadTrackCompletesSuccessfully() async throws {
		let backend = StubBackendRepository()
		let offliner = createOffliner(backendRepository: backend)

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
		let backend = StubBackendRepository()
		let offliner = createOffliner(backendRepository: backend)

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

	func testDownloadTrackFailsWhenMediaDownloadFails() async throws {
		let backend = StubBackendRepository()
		let offliner = createOffliner(backendRepository: backend, mediaDownloader: FailingMediaDownloader())

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
		let backend = StubBackendRepository()
		let offliner = createOffliner(backendRepository: backend, mediaDownloader: FailingMediaDownloader())

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
		let backend = StubBackendRepository()
		let offliner = createOffliner(backendRepository: backend)

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
		let backend = StubBackendRepository()
		let media = SucceedingMediaDownloader()
		media.progressValues = [0.25, 0.5, 0.75]

		let offliner = createOffliner(backendRepository: backend, mediaDownloader: media)

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
		let backend = StubBackendRepository()
		let offliner = createOffliner(backendRepository: backend, artworkDownloader: FailingArtworkRepository())

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
		let backend = StubBackendRepository()
		let offliner = createOffliner(backendRepository: backend)

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
		let backend = StubBackendRepository()
		let offliner = createOffliner(backendRepository: backend)

		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()

		let downloads = await offliner.currentDownloads
		XCTAssertEqual(downloads.count, 0)
	}

	func testDownloadAlbumStoresInLocalDatabase() async throws {
		let backend = StubBackendRepository()
		let offliner = createOffliner(backendRepository: backend)

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

	func testDownloadAlbumFailsWhenArtworkDownloadFails() async throws {
		let backend = StubBackendRepository()
		let offliner = createOffliner(backendRepository: backend, artworkDownloader: FailingArtworkRepository())

		try await offliner.download(collectionType: .albums, resourceId: "album-123")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try offliner.getOfflineCollection(collectionType: .albums, resourceId: "album-123")
		XCTAssertNil(storedCollection)
	}

	// MARK: - Playlist Download Tests

	func testDownloadPlaylistStoresInLocalDatabase() async throws {
		let backend = StubBackendRepository()
		let offliner = createOffliner(backendRepository: backend)

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
		let offliner = createOffliner(backendRepository: backend, artworkDownloader: FailingArtworkRepository())

		try await offliner.download(collectionType: .playlists, resourceId: "playlist-456")
		try await offliner.run()
		await backend.waitForTasksToComplete()

		let storedCollection = try offliner.getOfflineCollection(collectionType: .playlists, resourceId: "playlist-456")
		XCTAssertNil(storedCollection)
	}

	// MARK: - Helpers

	private func createOffliner(
		backendRepository: BackendRepositoryProtocol,
		artworkDownloader: ArtworkRepositoryProtocol = SucceedingArtworkRepository(),
		mediaDownloader: MediaDownloaderProtocol = SucceedingMediaDownloader()
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

final class SucceedingArtworkRepository: ArtworkRepositoryProtocol {
	let artworkURL: URL

	init() {
		let tempDir = FileManager.default.temporaryDirectory
		artworkURL = tempDir.appendingPathComponent("artwork-\(UUID().uuidString).jpg")
		try? Data().write(to: artworkURL)
	}

	func downloadArtwork(for task: StoreItemTask) async throws -> URL {
		artworkURL
	}

	func downloadArtwork(for task: StoreCollectionTask) async throws -> URL {
		artworkURL
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
	let downloadedFileURL: URL
	var progressValues: [Double] = []

	init() {
		let tempDir = FileManager.default.temporaryDirectory
		downloadedFileURL = tempDir.appendingPathComponent("media-\(UUID().uuidString).m4a")
		try? Data().write(to: downloadedFileURL)
	}

	func download(
		manifestURL: URL,
		taskId: String,
		onProgress: @escaping (Double) -> Void
	) async throws -> MediaDownloadResult {
		for progress in progressValues {
			onProgress(progress)
		}

		return MediaDownloadResult(
			mediaURL: downloadedFileURL,
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
