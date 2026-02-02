import Auth
import Foundation
import TidalAPI

// MARK: - ItemKey

struct ItemKey: Hashable {
	let type: String
	let id: String
}

// MARK: - ResourceType

enum ResourceType {
	case track
	case video
	case album
	case playlist
	case userCollection
}

// MARK: - Task Types

struct StoreItemTask {
	let id: String
	let metadata: OfflineMediaItem.Metadata
	let collectionId: String
	let volume: Int
	let index: Int
}

struct StoreCollectionTask {
	let id: String
	let metadata: OfflineCollection.Metadata
}

struct RemoveItemTask {
	let id: String
	let metadata: OfflineMediaItem.Metadata
}

struct RemoveCollectionTask {
	let id: String
	let metadata: OfflineCollection.Metadata
}

// MARK: - OfflineTask

enum OfflineTask {
	case storeItem(StoreItemTask)
	case storeCollection(StoreCollectionTask)
	case removeItem(RemoveItemTask)
	case removeCollection(RemoveCollectionTask)

	var id: String {
		switch self {
		case .storeItem(let task): return task.id
		case .storeCollection(let task): return task.id
		case .removeItem(let task): return task.id
		case .removeCollection(let task): return task.id
		}
	}
}

// MARK: - BackendRepository

final class BackendRepository {
	private let installationId: String

	init(credentialsProvider: CredentialsProvider, installationId: String) {
		if OpenAPIClientAPI.credentialsProvider == nil {
			OpenAPIClientAPI.credentialsProvider = credentialsProvider
		}

		self.installationId = installationId
	}

	func addItem(type: ResourceType, id: String) async throws {
		let identifier = InstallationsOfflineInventoryItemIdentifier(id: id, type: mapResourceType(type))
		let payload = InstallationsOfflineInventoryAddPayload(data: [identifier])

		try await InstallationsAPITidal.installationsIdRelationshipsOfflineInventoryPost(
			id: installationId,
			installationsOfflineInventoryAddPayload: payload
		)
	}

	func removeItem(type: ResourceType, id: String) async throws {
		let identifier = InstallationsOfflineInventoryItemIdentifier(id: id, type: mapResourceType(type))
		let payload = InstallationsOfflineInventoryRemovePayload(data: [identifier])

		try await InstallationsAPITidal.installationsIdRelationshipsOfflineInventoryDelete(
			id: installationId,
			installationsOfflineInventoryRemovePayload: payload
		)
	}

	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) {
		let response = try await OfflineTasksAPITidal.offlineTasksGet(
			pageCursor: cursor,
			include: ["item"],
			filterInstallationId: [installationId]
		)

		let (items, collections) = buildIncludedMaps(from: response.included)

		let tasks = response.data.compactMap { resourceObject -> OfflineTask? in
			guard let attributes = resourceObject.attributes,
				  let itemData = resourceObject.relationships?.item.data else {
				return nil
			}

			let key = ItemKey(type: itemData.type, id: itemData.id)

			switch attributes.action {
			case .storeItem:
				guard let metadata = items[key],
					  let volume = attributes.volume,
					  let collectionId = Optional("TODO"),
					  let index = attributes.index else {
					return nil
				}

				let task = StoreItemTask(id: resourceObject.id, metadata: metadata, collectionId: collectionId, volume: volume, index: index)
				return .storeItem(task)

			case .storeCollection:
				guard let metadata = collections[key] else {
					return nil
				}

				let task = StoreCollectionTask(id: resourceObject.id, metadata: metadata)
				return .storeCollection(task)

			case .removeItem:
				guard let metadata = items[key] else {
					return nil
				}

				let task = RemoveItemTask(id: resourceObject.id, metadata: metadata)
				return .removeItem(task)

			case .removeCollection:
				guard let metadata = collections[key] else {
					return nil
				}

				let task = RemoveCollectionTask(id: resourceObject.id, metadata: metadata)
				return .removeCollection(task)
			}
		}

		return (tasks, response.links.meta?.nextCursor)
	}

	func updateTask(taskId: String, state: Download.State) async throws {
		let attributes = OfflineTasksUpdateOperationPayloadDataAttributes(state: mapTaskState(state))
		let data = OfflineTasksUpdateOperationPayloadData(
			attributes: attributes,
			id: taskId,
			type: .offlinetasks
		)
		let payload = OfflineTasksUpdateOperationPayload(data: data)

		try await OfflineTasksAPITidal.offlineTasksIdPatch(
			id: taskId,
			offlineTasksUpdateOperationPayload: payload
		)
	}
}

// MARK: - Private Helpers

private extension BackendRepository {
	func buildIncludedMaps(from included: [IncludedInner]?) -> (items: [ItemKey: OfflineMediaItem.Metadata], collections: [ItemKey: OfflineCollection.Metadata]) {
		guard let included else { return ([:], [:]) }

		var items: [ItemKey: OfflineMediaItem.Metadata] = [:]
		var collections: [ItemKey: OfflineCollection.Metadata] = [:]

		for item in included {
			switch item {
			case .tracksResourceObject(let track):
				items[ItemKey(type: track.type, id: track.id)] = .track(track)
			case .videosResourceObject(let video):
				items[ItemKey(type: video.type, id: video.id)] = .video(video)
			case .albumsResourceObject(let album):
				collections[ItemKey(type: album.type, id: album.id)] = .album(album)
			case .playlistsResourceObject(let playlist):
				collections[ItemKey(type: playlist.type, id: playlist.id)] = .playlist(playlist)
			default:
				break
			}
		}

		return (items, collections)
	}

	func mapResourceType(_ type: ResourceType) -> InstallationsOfflineInventoryItemIdentifier.ModelType {
		switch type {
		case .track:
			return .tracks
		case .video:
			return .videos
		case .album:
			return .albums
		case .playlist:
			return .playlists
		case .userCollection:
			return .userCollection
		}
	}

	func mapTaskState(_ state: Download.State) -> OfflineTasksUpdateOperationPayloadDataAttributes.State {
		switch state {
		case .pending, .inProgress:
			return .inProgress
		case .failed:
			return .failed
		case .completed:
			return .completed
		}
	}
}
