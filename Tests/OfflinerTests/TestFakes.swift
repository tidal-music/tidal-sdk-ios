@testable import Offliner
import Foundation
import TidalAPI

// MARK: - Backend Client Fakes

final class StubBackendClient: BackendClientProtocol {
	private(set) var tasks: [OfflineTask] = []
	var taskIdCounter = 0

	func enqueueTasks(_ newTasks: [OfflineTask]) {
		tasks.append(contentsOf: newTasks)
	}

	func addItem(type: ResourceType, id: String) async throws {
		let taskId = "task-\(taskIdCounter)"
		let position = taskIdCounter + 1
		taskIdCounter += 1

		let defaultCollectionMetadata = BackendCollectionMetadata.album(
			AlbumsResourceObject(id: "stub-album", type: "albums")
		)

		switch type {
		case .track:
			let task = StoreItemTask(
				id: taskId,
				itemMetadata: .track(TracksResourceObject(id: id, type: "tracks")),
				artists: [],
				artwork: nil,
				collectionMetadata: defaultCollectionMetadata,
				volume: 1,
				position: position
			)
			tasks.append(.storeItem(task))

		case .video:
			let task = StoreItemTask(
				id: taskId,
				itemMetadata: .video(VideosResourceObject(id: id, type: "videos")),
				artists: [],
				artwork: nil,
				collectionMetadata: defaultCollectionMetadata,
				volume: 1,
				position: position
			)
			tasks.append(.storeItem(task))

		case .album:
			let task = StoreCollectionTask(
				id: taskId,
				metadata: .album(AlbumsResourceObject(id: id, type: "albums")),
				artists: [],
				artwork: nil
			)
			tasks.append(.storeCollection(task))

		case .playlist:
			let task = StoreCollectionTask(
				id: taskId,
				metadata: .playlist(PlaylistsResourceObject(id: id, type: "playlists")),
				artists: [],
				artwork: nil
			)
			tasks.append(.storeCollection(task))
		}
	}

	func removeItem(type: ResourceType, id: String) async throws {
		let taskId = "task-\(taskIdCounter)"
		taskIdCounter += 1

		let resourceType: String
		switch type {
		case .track: resourceType = "tracks"
		case .video: resourceType = "videos"
		case .album: resourceType = "albums"
		case .playlist: resourceType = "playlists"
		}

		let task = RemoveTask(id: taskId, resourceType: resourceType, resourceId: id)
		tasks.append(.remove(task))
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
	func downloadArtwork(for task: StoreItemTask) async throws -> URL? {
		createArtworkFile()
	}

	func downloadArtwork(for task: StoreCollectionTask) async throws -> URL? {
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
	func downloadArtwork(for task: StoreItemTask) async throws -> URL? {
		throw FakeError.artworkDownloadFailed
	}

	func downloadArtwork(for task: StoreCollectionTask) async throws -> URL? {
		throw FakeError.artworkDownloadFailed
	}
}

// MARK: - Media Downloader Fakes

final class SucceedingMediaDownloader: MediaDownloaderProtocol {
	var audioFormat: AudioFormat = .heaacv1
	var progressValues: [Double] = []

	func download(
		trackId: String,
		taskId: String,
		onProgress: @escaping @Sendable (Double) async -> Void
	) async throws -> MediaDownloadResult {
		for progress in progressValues {
			await onProgress(progress)
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
	var audioFormat: AudioFormat = .heaacv1

	func download(
		trackId: String,
		taskId: String,
		onProgress: @escaping @Sendable (Double) async -> Void
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
