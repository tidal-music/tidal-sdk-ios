import Foundation
import GRDB
import TidalAPI

// MARK: - Public Types

public enum OfflineMediaItemType: String {
	case tracks
	case videos
}

public enum OfflineCollectionType: String {
	case albums
	case playlists
}

public struct OfflineMediaItem {
	public struct TrackMetadata: Codable {
		public let track: TracksResourceObject
		public let artists: [ArtistsResourceObject]
		public let coverArt: ArtworksResourceObject?
	}

	public struct VideoMetadata: Codable {
		public let video: VideosResourceObject
		public let artists: [ArtistsResourceObject]
		public let thumbnail: ArtworksResourceObject?
	}

	public enum Metadata {
		case track(TrackMetadata)
		case video(VideoMetadata)
	}

	public let id: String
	public let metadata: Metadata
	public let mediaURL: URL
	public let licenseURL: URL?
	public let artworkURL: URL?
}

public struct OfflineCollection {
	public struct AlbumMetadata: Codable {
		public let album: AlbumsResourceObject
		public let artists: [ArtistsResourceObject]
		public let coverArt: ArtworksResourceObject?
	}

	public struct PlaylistMetadata: Codable {
		public let playlist: PlaylistsResourceObject
		public let coverArt: ArtworksResourceObject?
	}

	public enum Metadata {
		case album(AlbumMetadata)
		case playlist(PlaylistMetadata)
	}

	public let id: String
	public let metadata: Metadata
	public let artworkURL: URL?
}

public struct OfflineCollectionItem {
	public let item: OfflineMediaItem
	public let volume: Int
	public let position: Int
}

// MARK: - Offliner

public final class Offliner {
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore
	private let taskRunner: TaskRunner

	public var newDownloads: AsyncStream<Download> {
		taskRunner.newDownloads
	}

	public var currentDownloads: [Download] {
		get async {
			await taskRunner.currentDownloads
		}
	}

	public init(installationId: String) throws {
		let databaseQueue = try DatabaseQueue(path: OfflineStore.url().path)
		try Migrations.run(databaseQueue)

		let offlineStore = OfflineStore(databaseQueue)
		let backendClient = BackendClient(installationId: installationId)
		let artworkDownloader = ArtworkDownloader()
		let mediaDownloader = MediaDownloader()

		self.backendClient = backendClient
		self.offlineStore = offlineStore
		self.taskRunner = TaskRunner(
			backendClient: backendClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader
		)
	}

	init(
		backendClient: BackendClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.backendClient = backendClient
		self.offlineStore = offlineStore
		self.taskRunner = TaskRunner(
			backendClient: backendClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader
		)
	}

	public func run() async throws {
		try await taskRunner.run()
	}

	// MARK: - Offline Content

	public func getOfflineMediaItem(mediaType: OfflineMediaItemType, resourceId: String) throws -> OfflineMediaItem? {
		try offlineStore.getMediaItem(mediaType: mediaType, resourceId: resourceId)
	}

	public func getOfflineMediaItems(mediaType: OfflineMediaItemType) throws -> [OfflineMediaItem] {
		try offlineStore.getMediaItems(mediaType: mediaType)
	}

	public func getOfflineCollection(
		collectionType: OfflineCollectionType,
		resourceId: String
	) throws -> OfflineCollection? {
		try offlineStore.getCollection(collectionType: collectionType, resourceId: resourceId)
	}

	public func getOfflineCollections(collectionType: OfflineCollectionType) throws -> [OfflineCollection] {
		try offlineStore.getCollections(collectionType: collectionType)
	}

	public func getOfflineCollectionItems(
		collectionType: OfflineCollectionType,
		resourceId: String
	) throws -> [OfflineCollectionItem] {
		try offlineStore.getCollectionItems(collectionType: collectionType, resourceId: resourceId)
	}

	// MARK: - Download/Remove

	public func download(mediaType: OfflineMediaItemType, resourceId: String) async throws {
		try await backendClient.addItem(type: mediaType.toResourceType, id: resourceId)
	}

	public func download(collectionType: OfflineCollectionType, resourceId: String) async throws {
		try await backendClient.addItem(type: collectionType.toResourceType, id: resourceId)
	}

	public func remove(mediaType: OfflineMediaItemType, resourceId: String) async throws {
		try await backendClient.removeItem(type: mediaType.toResourceType, id: resourceId)
	}

	public func remove(collectionType: OfflineCollectionType, resourceId: String) async throws {
		try await backendClient.removeItem(type: collectionType.toResourceType, id: resourceId)
	}
}

// MARK: - Internal Mappings

extension OfflineMediaItemType {
	var toResourceType: ResourceType {
		switch self {
		case .tracks: return .track
		case .videos: return .video
		}
	}
}

extension OfflineCollectionType {
	var toResourceType: ResourceType {
		switch self {
		case .albums: return .album
		case .playlists: return .playlist
		}
	}
}
