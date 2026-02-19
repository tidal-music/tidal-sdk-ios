import Auth
import Foundation
import TidalAPI

// MARK: - ResourceType

enum ResourceType {
	case track
	case video
	case album
	case playlist
}

// MARK: - Task Types

struct StoreItemTask {
	let id: String
	let itemMetadata: OfflineMediaItem.Metadata
	let collectionMetadata: OfflineCollection.Metadata
	let volume: Int
	let position: Int
}

struct StoreCollectionTask {
	let id: String
	let metadata: OfflineCollection.Metadata
}

struct RemoveTask {
	let id: String
	let resourceType: String
	let resourceId: String
}

// MARK: - OfflineTask

enum OfflineTask {
	case storeItem(StoreItemTask)
	case storeCollection(StoreCollectionTask)
	case remove(RemoveTask)

	var id: String {
		switch self {
		case .storeItem(let task): return task.id
		case .storeCollection(let task): return task.id
		case .remove(let task): return task.id
		}
	}
}

// MARK: - Metadata Extensions

extension OfflineMediaItem.Metadata {
	var resourceType: String {
		switch self {
		case .track: return OfflineMediaItemType.tracks.rawValue
		case .video: return OfflineMediaItemType.videos.rawValue
		}
	}

	var resourceId: String {
		switch self {
		case .track(let metadata): return metadata.track.id
		case .video(let metadata): return metadata.video.id
		}
	}
}

extension OfflineCollection.Metadata {
	var resourceType: String {
		switch self {
		case .album: return OfflineCollectionType.albums.rawValue
		case .playlist: return OfflineCollectionType.playlists.rawValue
		}
	}

	var resourceId: String {
		switch self {
		case .album(let metadata): return metadata.album.id
		case .playlist(let metadata): return metadata.playlist.id
		}
	}
}

// MARK: - BackendClientProtocol

protocol BackendClientProtocol {
	func addItem(type: ResourceType, id: String) async throws
	func removeItem(type: ResourceType, id: String) async throws
	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?)
	func updateTask(taskId: String, state: Download.State) async throws
}

// MARK: - BackendClient

final class BackendClient: BackendClientProtocol {
	private let installationId: String

	init(installationId: String) {
		self.installationId = installationId
	}

	func addItem(type: ResourceType, id: String) async throws {
		let identifier = InstallationsOfflineInventoryItemIdentifier(id: id, type: mapResourceType(type))
		let payload = InstallationsOfflineInventoryRelationshipAddOperationPayload(data: [identifier])

		try await InstallationsAPITidal.installationsIdRelationshipsOfflineInventoryPost(
			id: installationId,
			installationsOfflineInventoryRelationshipAddOperationPayload: payload
		)
	}

	func removeItem(type: ResourceType, id: String) async throws {
		let identifier = InstallationsOfflineInventoryItemIdentifier(id: id, type: mapResourceType(type))
		let payload = InstallationsOfflineInventoryRelationshipRemoveOperationPayload(data: [identifier])

		try await InstallationsAPITidal.installationsIdRelationshipsOfflineInventoryDelete(
			id: installationId,
			installationsOfflineInventoryRelationshipRemoveOperationPayload: payload
		)
	}

	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?) {
		let response = try await OfflineTasksAPITidal.offlineTasksGet(
			pageCursor: cursor,
			include: ["item", "item.albums.coverArt", "item.coverArt", "item.thumbnailArt", "item.artists", "collection"],
			filterInstallationId: [installationId]
		)

		let tasks = response.createOfflineTaskMap()

		for (taskId, task) in tasks where task == nil {
			try? await updateTask(taskId: taskId, state: .failed)
		}

		return (tasks.compactMap(\.1), response.links.meta?.nextCursor)
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

private extension BackendClient {
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

// MARK: - Response Mapping

private extension OfflineTasksMultiResourceDataDocument {
	func createOfflineTaskMap() -> [(String, OfflineTask?)] {
		let includedItems = IncludedItemsMap(from: included)
		return data.map { ($0.id, $0.createOfflineTask(includedItems: includedItems)) }
	}
}

private extension OfflineTasksResourceObject {
	func createOfflineTask(includedItems: IncludedItemsMap) -> OfflineTask? {
		guard let attributes else {
			return nil
		}

		let includedItem = relationships?.item?.data
			.flatMap { includedItems.get(type: $0.type, id: $0.id) }

		let includedCollection = relationships?.collection?.data
			.flatMap { includedItems.get(type: $0.type, id: $0.id) }

		switch attributes.action {
		case .storeItem:
			return StoreItemTask(self, attributes: attributes, item: includedItem, collection: includedCollection)
				.map { .storeItem($0) }
		case .storeCollection:
			return StoreCollectionTask(self, item: includedItem)
				.map { .storeCollection($0) }
		case .removeItem, .removeCollection:
			return RemoveTask(self)
				.map { .remove($0) }
		}
	}
}

// MARK: - IncludedItemsMap

private final class IncludedItemsMap {
	private struct Key: Hashable {
		let type: String
		let id: String
	}

	private var storage: [Key: IncludedItem] = [:]

	init(from included: [IncludedInner]?) {
		guard let included else { return }
		populateStorage(from: included)
		wireAllRelationships(from: included)
	}

	private func populateStorage(from included: [IncludedInner]) {
		for item in included {
			switch item {
			case .tracksResourceObject(let track):
				add(IncludedItem(resource: .track(track)), type: track.type, id: track.id)
			case .videosResourceObject(let video):
				add(IncludedItem(resource: .video(video)), type: video.type, id: video.id)
			case .albumsResourceObject(let album):
				add(IncludedItem(resource: .album(album)), type: album.type, id: album.id)
			case .playlistsResourceObject(let playlist):
				add(IncludedItem(resource: .playlist(playlist)), type: playlist.type, id: playlist.id)
			case .artworksResourceObject(let artwork):
				add(IncludedItem(resource: .artwork(artwork)), type: artwork.type, id: artwork.id)
			case .artistsResourceObject(let artist):
				add(IncludedItem(resource: .artist(artist)), type: artist.type, id: artist.id)
			default:
				break
			}
		}
	}

	private func wireAllRelationships(from included: [IncludedInner]) {
		for item in included {
			switch item {
			case .tracksResourceObject(let track):
				guard let includedItem = get(type: track.type, id: track.id),
					  let rels = track.relationships else { continue }
				wireRelationships(for: includedItem, albums: rels.albums, artists: rels.artists, coverArt: nil)

			case .videosResourceObject(let video):
				guard let includedItem = get(type: video.type, id: video.id),
					  let rels = video.relationships else { continue }
				wireRelationships(for: includedItem, albums: rels.albums, artists: rels.artists, coverArt: rels.thumbnailArt)

			case .albumsResourceObject(let album):
				guard let includedItem = get(type: album.type, id: album.id),
					  let rels = album.relationships else { continue }
				wireRelationships(for: includedItem, albums: nil, artists: rels.artists, coverArt: rels.coverArt)

			case .playlistsResourceObject(let playlist):
				guard let includedItem = get(type: playlist.type, id: playlist.id),
					  let rels = playlist.relationships else { continue }
				wireRelationships(for: includedItem, albums: nil, artists: nil, coverArt: rels.coverArt)

			default:
				break
			}
		}
	}

	func get(type: String, id: String) -> IncludedItem? {
		storage[Key(type: type, id: id)]
	}

	private func add(_ item: IncludedItem, type: String, id: String) {
		storage[Key(type: type, id: id)] = item
	}

	private func wireRelationships(
		for item: IncludedItem,
		albums: MultiRelationshipDataDocument?,
		artists: MultiRelationshipDataDocument?,
		coverArt: MultiRelationshipDataDocument?
	) {
		if let albumData = albums?.data?.first {
			item.album = get(type: albumData.type, id: albumData.id)
		}

		if let artistsData = artists?.data, !artistsData.isEmpty {
			item.artists = artistsData.compactMap { artistData in
				get(type: artistData.type, id: artistData.id)
			}
		}

		if let coverArtData = coverArt?.data?.first {
			item.coverArt = get(type: coverArtData.type, id: coverArtData.id)
		}
	}
}

// MARK: - IncludedResource

private enum IncludedResource {
	case track(TracksResourceObject)
	case video(VideosResourceObject)
	case album(AlbumsResourceObject)
	case playlist(PlaylistsResourceObject)
	case artwork(ArtworksResourceObject)
	case artist(ArtistsResourceObject)
}

// MARK: - IncludedItem

private class IncludedItem {
	let resource: IncludedResource
	var album: IncludedItem?
	var coverArt: IncludedItem?
	var artists: [IncludedItem]?

	init(resource: IncludedResource) {
		self.resource = resource
	}

	var mediaItemMetadata: OfflineMediaItem.Metadata? {
		switch resource {
		case .track(let track):
			let artistObjects = artists?.compactMap { item -> ArtistsResourceObject? in
				if case .artist(let artist) = item.resource { return artist }
				return nil
			} ?? []
			let coverArtObject: ArtworksResourceObject? = {
				if case .artwork(let artwork) = album?.coverArt?.resource { return artwork }
				return nil
			}()
			let metadata = OfflineMediaItem.TrackMetadata(track: track, artists: artistObjects, coverArt: coverArtObject)
			return .track(metadata)

		case .video(let video):
			let artistObjects = artists?.compactMap { item -> ArtistsResourceObject? in
				if case .artist(let artist) = item.resource { return artist }
				return nil
			} ?? []
			let thumbnailObject: ArtworksResourceObject? = {
				if case .artwork(let artwork) = coverArt?.resource { return artwork }
				return nil
			}()
			let metadata = OfflineMediaItem.VideoMetadata(video: video, artists: artistObjects, thumbnail: thumbnailObject)
			return .video(metadata)

		default:
			return nil
		}
	}

	var collectionMetadata: OfflineCollection.Metadata? {
		switch resource {
		case .album(let album):
			let artistObjects = artists?.compactMap { item -> ArtistsResourceObject? in
				if case .artist(let artist) = item.resource { return artist }
				return nil
			} ?? []
			let coverArtObject: ArtworksResourceObject? = {
				if case .artwork(let artwork) = coverArt?.resource { return artwork }
				return nil
			}()
			let metadata = OfflineCollection.AlbumMetadata(album: album, artists: artistObjects, coverArt: coverArtObject)
			return .album(metadata)

		case .playlist(let playlist):
			let coverArtObject: ArtworksResourceObject? = {
				if case .artwork(let artwork) = coverArt?.resource { return artwork }
				return nil
			}()
			let metadata = OfflineCollection.PlaylistMetadata(playlist: playlist, coverArt: coverArtObject)
			return .playlist(metadata)

		default:
			return nil
		}
	}
}

// MARK: - Task Mapping Extensions

private extension StoreItemTask {
	init?(
		_ resourceObject: OfflineTasksResourceObject,
		attributes: OfflineTasksAttributes,
		item: IncludedItem?,
		collection: IncludedItem?
	) {
		guard let itemMetadata = item?.mediaItemMetadata,
			  let collectionMetadata = collection?.collectionMetadata,
			  let volume = attributes.volume,
			  let position = attributes.position else {
			return nil
		}

		self.init(
			id: resourceObject.id,
			itemMetadata: itemMetadata,
			collectionMetadata: collectionMetadata,
			volume: volume,
			position: position
		)
	}
}

private extension StoreCollectionTask {
	init?(_ resourceObject: OfflineTasksResourceObject, item: IncludedItem?) {
		guard let metadata = item?.collectionMetadata else {
			return nil
		}
		self.init(id: resourceObject.id, metadata: metadata)
	}
}

private extension RemoveTask {
	init?(_ resourceObject: OfflineTasksResourceObject) {
		guard let itemData = resourceObject.relationships?.item?.data else {
			return nil
		}
		self.init(id: resourceObject.id, resourceType: itemData.type, resourceId: itemData.id)
	}
}
