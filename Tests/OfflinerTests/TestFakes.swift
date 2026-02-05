@testable import Offliner
import Foundation
import TidalAPI

// MARK: - Backend Client Fakes

final class StubBackendClient: BackendClientProtocol {
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
			let task = StoreItemTask(
				id: taskId,
				metadata: .track(metadata),
				collectionId: "collection-1",
				volume: 1,
				index: index
			)
			tasks.append(.storeItem(task))

		case .video:
			let video = VideosResourceObject(id: id, type: "videos")
			let metadata = OfflineMediaItem.VideoMetadata(video: video, artists: [], thumbnail: nil)
			let task = StoreItemTask(
				id: taskId,
				metadata: .video(metadata),
				collectionId: "collection-1",
				volume: 1,
				index: index
			)
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

final class FailingBackendClient: BackendClientProtocol {
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

final class FailOnUpdateToInProgressBackendClient: BackendClientProtocol {
	private let stub = StubBackendClient()

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

final class FailOnUpdateToCompletedBackendClient: BackendClientProtocol {
	private let stub = StubBackendClient()

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

final class FailOnGetTasksBackendClient: BackendClientProtocol {
	func addItem(type: ResourceType, id: String) async throws {}

	func removeItem(type: ResourceType, id: String) async throws {}

	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) {
		throw FakeError.backendFailed
	}

	func updateTask(taskId: String, state: Download.State) async throws {}
}

// MARK: - Artwork Downloader Fakes

final class SucceedingArtworkDownloader: ArtworkDownloaderProtocol {
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

final class FailingArtworkDownloader: ArtworkDownloaderProtocol {
	func downloadArtwork(for task: StoreItemTask) async throws -> URL {
		throw FakeError.artworkDownloadFailed
	}

	func downloadArtwork(for task: StoreCollectionTask) async throws -> URL {
		throw FakeError.artworkDownloadFailed
	}
}

// MARK: - Media Downloader Fakes

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
			requiresLicense: false,
			mediaLocation: url,
			licenseLocation: nil
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

// MARK: - Errors

enum FakeError: Error {
	case backendFailed
	case artworkDownloadFailed
	case downloadFailed
}
