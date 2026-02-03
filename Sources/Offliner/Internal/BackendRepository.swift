import Auth
import Foundation
import TidalAPI

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

// MARK: - BackendRepositoryProtocol

protocol BackendRepositoryProtocol {
	func addItem(type: ResourceType, id: String) async throws
	func removeItem(type: ResourceType, id: String) async throws
	func getTasks(cursor: String?) async throws -> (tasks: [OfflineTask], cursor: String?)
	func updateTask(taskId: String, state: Download.State) async throws
}

// MARK: - BackendRepository

final class BackendRepository: BackendRepositoryProtocol {
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
			include: ["item", "item.album.coverArt", "item.coverArt", "item.artists"],
			filterInstallationId: [installationId]
		)

		let includedItems = IncludedItemsMap(from: response.included)

		let tasks = response.data.compactMap { resourceObject -> OfflineTask? in
			guard let attributes = resourceObject.attributes,
				  let itemData = resourceObject.relationships?.item.data else {
				return nil
			}

			guard let includedItem = includedItems.get(type: itemData.type, id: itemData.id) else { return nil }

			switch attributes.action {
			case .storeItem:
				guard let metadata = includedItem.mediaItemMetadata,
					  let volume = attributes.volume,
					  let collectionId = Optional("TODO"),
					  let index = attributes.index else {
					return nil
				}

				let task = StoreItemTask(id: resourceObject.id, metadata: metadata, collectionId: collectionId, volume: volume, index: index)
				return .storeItem(task)

			case .storeCollection:
				guard let metadata = includedItem.collectionMetadata else {
					return nil
				}

				let task = StoreCollectionTask(id: resourceObject.id, metadata: metadata)
				return .storeCollection(task)

			case .removeItem:
				guard let metadata = includedItem.mediaItemMetadata else {
					return nil
				}

				let task = RemoveItemTask(id: resourceObject.id, metadata: metadata)
				return .removeItem(task)

			case .removeCollection:
				guard let metadata = includedItem.collectionMetadata else {
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

// MARK: - IncludedItemsMap

private final class IncludedItemsMap {
	private struct Key: Hashable {
		let type: String
		let id: String
	}

	private var storage: [Key: IncludedItem] = [:]

	init(from included: [IncludedInner]?) {
		guard let included else { return }

		// First pass: create all IncludedItem nodes
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

		// Second pass: wire up relationships
		for item in included {
			switch item {
			case .tracksResourceObject(let track):
				guard let includedItem = get(type: track.type, id: track.id), let rels = track.relationships else { continue }
				wireRelationships(for: includedItem, albums: rels.albums, artists: rels.artists, coverArt: nil)

			case .videosResourceObject(let video):
				guard let includedItem = get(type: video.type, id: video.id), let rels = video.relationships else { continue }
				wireRelationships(for: includedItem, albums: rels.albums, artists: rels.artists, coverArt: rels.thumbnailArt)

			case .albumsResourceObject(let album):
				guard let includedItem = get(type: album.type, id: album.id), let rels = album.relationships else { continue }
				wireRelationships(for: includedItem, albums: nil, artists: rels.artists, coverArt: rels.coverArt)

			case .playlistsResourceObject(let playlist):
				guard let includedItem = get(type: playlist.type, id: playlist.id), let rels = playlist.relationships else { continue }
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
