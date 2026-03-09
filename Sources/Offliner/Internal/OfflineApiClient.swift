import Auth
import Foundation
import TidalAPI

// MARK: - ResourceType

enum ResourceType {
	case track
	case video
	case album
	case playlist
	case userCollectionTracks
}

// MARK: - Task Types

struct StoreTrackTask {
	let id: String
	let track: TracksResourceObject
	let artists: [ArtistsResourceObject]
	let artwork: ArtworksResourceObject?
	let collectionResourceType: String
	let collectionResourceId: String
	let volume: Int
	let position: Int
}

struct StoreVideoTask {
	let id: String
	let video: VideosResourceObject
	let artists: [ArtistsResourceObject]
	let artwork: ArtworksResourceObject?
	let collectionResourceType: String
	let collectionResourceId: String
	let volume: Int
	let position: Int
}

struct StoreAlbumTask {
	let id: String
	let album: AlbumsResourceObject
	let artists: [ArtistsResourceObject]
	let artwork: ArtworksResourceObject?
}

struct StorePlaylistTask {
	let id: String
	let playlist: PlaylistsResourceObject
	let artwork: ArtworksResourceObject?
}

struct StoreUserCollectionTracksTask {
	let id: String
	let userCollectionTracks: UserCollectionTracksResourceObject
}

struct RemoveItemTask {
	let id: String
	let resourceType: String
	let resourceId: String
	let collectionResourceType: String
	let collectionResourceId: String
}

struct RemoveCollectionTask {
	let id: String
	let resourceType: String
	let resourceId: String
}

// MARK: - OfflineTask

enum OfflineTask {
	case storeTrack(StoreTrackTask)
	case storeVideo(StoreVideoTask)
	case storeAlbum(StoreAlbumTask)
	case storePlaylist(StorePlaylistTask)
	case storeUserCollectionTracks(StoreUserCollectionTracksTask)
	case removeItem(RemoveItemTask)
	case removeCollection(RemoveCollectionTask)

	var id: String {
		switch self {
		case .storeTrack(let task): return task.id
		case .storeVideo(let task): return task.id
		case .storeAlbum(let task): return task.id
		case .storePlaylist(let task): return task.id
		case .storeUserCollectionTracks(let task): return task.id
		case .removeItem(let task): return task.id
		case .removeCollection(let task): return task.id
		}
	}
}

// MARK: - OfflineApiClientProtocol

protocol OfflineApiClientProtocol {
	func addItem(type: ResourceType, id: String) async throws
	func removeItem(type: ResourceType, id: String) async throws
	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?)
	func updateTask(taskId: String, state: Download.State) async throws
}

// MARK: - OfflineApiClient

final class OfflineApiClient: OfflineApiClientProtocol {
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

private extension OfflineApiClient {
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
		case .userCollectionTracks:
			return .usercollectiontracks
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
		guard let attributes,
			  let itemData = relationships?.item?.data else {
			return nil
		}

		let collectionData = relationships?.collection?.data
		let includedItem = includedItems.get(type: itemData.type, id: itemData.id)

		switch attributes.action {
		case .store:
			switch itemData.type {
			case "tracks":
				return StoreTrackTask(self, attributes: attributes, item: includedItem, collectionData: collectionData)
					.map { .storeTrack($0) }
			case "videos":
				return StoreVideoTask(self, attributes: attributes, item: includedItem, collectionData: collectionData)
					.map { .storeVideo($0) }
			case "albums":
				return StoreAlbumTask(self, item: includedItem)
					.map { .storeAlbum($0) }
			case "playlists":
				return StorePlaylistTask(self, item: includedItem)
					.map { .storePlaylist($0) }
			case "userCollectionTracks":
				return StoreUserCollectionTracksTask(self, item: includedItem)
					.map { .storeUserCollectionTracks($0) }
			default:
				return nil
			}
		case .remove:
			switch itemData.type {
			case "tracks", "videos":
				return RemoveItemTask(self, itemData: itemData, collectionData: collectionData)
					.map { .removeItem($0) }
			case "albums", "playlists", "userCollectionTracks":
				return .removeCollection(RemoveCollectionTask(id: id, resourceType: itemData.type, resourceId: itemData.id))
			default:
				return nil
			}
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
			case .userCollectionTracksResourceObject(let uct):
				add(IncludedItem(resource: .userCollectionTracks(uct)), type: uct.type, id: uct.id)
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
	case userCollectionTracks(UserCollectionTracksResourceObject)
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

	var artistObjects: [ArtistsResourceObject] {
		artists?.compactMap { item -> ArtistsResourceObject? in
			if case .artist(let artist) = item.resource { return artist }
			return nil
		} ?? []
	}

	var artworkObject: ArtworksResourceObject? {
		let artworkItem: IncludedItem? = switch resource {
		case .track: album?.coverArt
		case .video: coverArt
		case .album: coverArt
		case .playlist: coverArt
		case .userCollectionTracks: nil
		default: nil
		}
		guard let artworkItem, case .artwork(let artwork) = artworkItem.resource else {
			return nil
		}
		return artwork
	}
}

// MARK: - Task Mapping Extensions

private extension StoreTrackTask {
	init?(_ resourceObject: OfflineTasksResourceObject, attributes: OfflineTasksAttributes, item: IncludedItem?, collectionData: ResourceIdentifier?) {
		guard let item, case .track(let track) = item.resource, let collectionData else { return nil }
		self.init(
			id: resourceObject.id,
			track: track,
			artists: item.artistObjects,
			artwork: item.artworkObject,
			collectionResourceType: collectionData.type,
			collectionResourceId: collectionData.id,
			volume: attributes.volume,
			position: attributes.position
		)
	}
}

private extension StoreVideoTask {
	init?(_ resourceObject: OfflineTasksResourceObject, attributes: OfflineTasksAttributes, item: IncludedItem?, collectionData: ResourceIdentifier?) {
		guard let item, case .video(let video) = item.resource, let collectionData else { return nil }
		self.init(
			id: resourceObject.id,
			video: video,
			artists: item.artistObjects,
			artwork: item.artworkObject,
			collectionResourceType: collectionData.type,
			collectionResourceId: collectionData.id,
			volume: attributes.volume,
			position: attributes.position
		)
	}
}

private extension StoreAlbumTask {
	init?(_ resourceObject: OfflineTasksResourceObject, item: IncludedItem?) {
		guard let item, case .album(let album) = item.resource else { return nil }
		self.init(id: resourceObject.id, album: album, artists: item.artistObjects, artwork: item.artworkObject)
	}
}

private extension StorePlaylistTask {
	init?(_ resourceObject: OfflineTasksResourceObject, item: IncludedItem?) {
		guard let item, case .playlist(let playlist) = item.resource else { return nil }
		self.init(id: resourceObject.id, playlist: playlist, artwork: item.artworkObject)
	}
}

private extension StoreUserCollectionTracksTask {
	init?(_ resourceObject: OfflineTasksResourceObject, item: IncludedItem?) {
		guard let item, case .userCollectionTracks(let uct) = item.resource else { return nil }
		self.init(id: resourceObject.id, userCollectionTracks: uct)
	}
}

private extension RemoveItemTask {
	init?(_ resourceObject: OfflineTasksResourceObject, itemData: ResourceIdentifier, collectionData: ResourceIdentifier?) {
		guard let collectionData else {
			return nil
		}
		self.init(
			id: resourceObject.id,
			resourceType: itemData.type,
			resourceId: itemData.id,
			collectionResourceType: collectionData.type,
			collectionResourceId: collectionData.id
		)
	}
}
