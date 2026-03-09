@testable import Offliner
import AVFoundation
import Foundation
import TidalAPI

// MARK: - Backend Client Fakes

final class StubOfflineApiClient: OfflineApiClientProtocol {
	private(set) var tasks: [OfflineTask] = []
	var taskIdCounter = 0

	func enqueueTasks(_ newTasks: [OfflineTask]) {
		tasks.append(contentsOf: newTasks)
	}

	func addItem(type: ResourceType, id: String) async throws {
		let taskId = "task-\(taskIdCounter)"
		let position = taskIdCounter + 1
		taskIdCounter += 1

		switch type {
		case .track:
			let task = StoreTrackTask(
				id: taskId,
				track: TracksResourceObject(id: id, type: "tracks"),
				artists: [],
				artwork: nil,
				collectionResourceType: "albums",
				collectionResourceId: "stub-album",
				volume: 1,
				position: position
			)
			tasks.append(.storeTrack(task))

		case .video:
			let task = StoreVideoTask(
				id: taskId,
				video: VideosResourceObject(id: id, type: "videos"),
				artists: [],
				artwork: nil,
				collectionResourceType: "albums",
				collectionResourceId: "stub-album",
				volume: 1,
				position: position
			)
			tasks.append(.storeVideo(task))

		case .album:
			let task = StoreAlbumTask(
				id: taskId,
				album: AlbumsResourceObject(id: id, type: "albums"),
				artists: [],
				artwork: nil
			)
			tasks.append(.storeAlbum(task))

		case .playlist:
			let task = StorePlaylistTask(
				id: taskId,
				playlist: PlaylistsResourceObject(id: id, type: "playlists"),
				artwork: nil
			)
			tasks.append(.storePlaylist(task))

		case .userCollectionTracks:
			let task = StoreUserCollectionTracksTask(
				id: taskId,
				userCollectionTracks: UserCollectionTracksResourceObject(id: id, type: "userCollectionTracks")
			)
			tasks.append(.storeUserCollectionTracks(task))
		}
	}

	func removeItem(type: ResourceType, id: String) async throws {
		let taskId = "task-\(taskIdCounter)"
		taskIdCounter += 1

		switch type {
		case .track:
			tasks.append(.removeItem(RemoveItemTask(
				id: taskId,
				resourceType: "tracks",
				resourceId: id,
				collectionResourceType: "albums",
				collectionResourceId: "stub-album"
			)))
		case .video:
			tasks.append(.removeItem(RemoveItemTask(
				id: taskId,
				resourceType: "videos",
				resourceId: id,
				collectionResourceType: "albums",
				collectionResourceId: "stub-album"
			)))
		case .album:
			tasks.append(.removeCollection(RemoveCollectionTask(
				id: taskId,
				resourceType: "albums",
				resourceId: id
			)))
		case .playlist:
			tasks.append(.removeCollection(RemoveCollectionTask(
				id: taskId,
				resourceType: "playlists",
				resourceId: id
			)))
		case .userCollectionTracks:
			tasks.append(.removeCollection(RemoveCollectionTask(
				id: taskId,
				resourceType: "userCollectionTracks",
				resourceId: id
			)))
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

final class FailingOfflineApiClient: OfflineApiClientProtocol {
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

final class FailOnUpdateToInProgressOfflineApiClient: OfflineApiClientProtocol {
	private let stub = StubOfflineApiClient()

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

final class FailOnUpdateToCompletedOfflineApiClient: OfflineApiClientProtocol {
	private let stub = StubOfflineApiClient()

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

final class FailOnGetTasksOfflineApiClient: OfflineApiClientProtocol {
	func addItem(type: ResourceType, id: String) async throws {}

	func removeItem(type: ResourceType, id: String) async throws {}

	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) {
		throw FakeError.backendFailed
	}

	func updateTask(taskId: String, state: Download.State) async throws {}
}

// MARK: - Artwork Downloader Fakes

final class SucceedingArtworkDownloader: ArtworkDownloaderProtocol {
	func downloadArtwork(for artwork: ArtworksResourceObject?) async throws -> URL? {
		let tempDir = FileManager.default.temporaryDirectory
		let url = tempDir.appendingPathComponent("artwork-\(UUID().uuidString).jpg")
		try? Data("artwork".utf8).write(to: url)
		return url
	}
}

final class FailingArtworkDownloader: ArtworkDownloaderProtocol {
	func downloadArtwork(for artwork: ArtworksResourceObject?) async throws -> URL? {
		throw FakeError.artworkDownloadFailed
	}
}

// MARK: - Media Downloader Fakes

final class SucceedingMediaDownloader: MediaDownloaderProtocol {
	var progressValues: [Double] = []

	func download(
		manifestURL: URL,
		contentKeySession: AVContentKeySession?,
		title: String,
		onProgress: @escaping @Sendable (Double) async -> Void
	) async throws -> MediaDownloadResult {
		for progress in progressValues {
			await onProgress(progress)
		}

		let tempDir = FileManager.default.temporaryDirectory
		let url = tempDir.appendingPathComponent("media-\(UUID().uuidString).m4a")
		try Data("media".utf8).write(to: url)

		return MediaDownloadResult(
			duration: 120,
			mediaLocation: url,
			licenseLocation: nil
		)
	}
}

final class FailingMediaDownloader: MediaDownloaderProtocol {
	func download(
		manifestURL: URL,
		contentKeySession: AVContentKeySession?,
		title: String,
		onProgress: @escaping @Sendable (Double) async -> Void
	) async throws -> MediaDownloadResult {
		throw FakeError.downloadFailed
	}
}

// MARK: - Manifest Fetcher Fakes

final class SucceedingTrackManifestFetcher: TrackManifestFetcherProtocol {
	var audioFormats: [AudioFormat] = [.heaacv1]

	func fetchTrackManifest(trackId: String) async throws -> ManifestFetchResult {
		ManifestFetchResult(
			manifestURL: URL(string: "data:application/vnd.apple.mpegurl;base64,fake")!,
			contentKeySession: nil,
			playbackMetadata: nil
		)
	}
}

final class SucceedingVideoManifestFetcher: VideoManifestFetcherProtocol {
	func fetchVideoManifest(videoId: String) async throws -> ManifestFetchResult {
		ManifestFetchResult(
			manifestURL: URL(string: "data:application/vnd.apple.mpegurl;base64,fake")!,
			contentKeySession: nil,
			playbackMetadata: nil
		)
	}
}

// MARK: - Errors

enum FakeError: Error {
	case backendFailed
	case artworkDownloadFailed
	case downloadFailed
}
