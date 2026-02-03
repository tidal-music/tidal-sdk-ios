import Auth
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
}

public struct OfflineCollectionItem {
	public let item: OfflineMediaItem
	public let volume: Int
	public let position: Int
}

// MARK: - Offliner

public final class Offliner {
	private let backendRepository: BackendRepositoryProtocol
	private let localRepository: LocalRepository
	private let taskRunner: TaskRunner

	public var newDownloads: AsyncStream<Download> {
		taskRunner.newDownloads
	}

	public var currentDownloads: [Download] {
		get async {
			await taskRunner.currentDownloads
		}
	}

	public init(credentialsProvider: CredentialsProvider, installationId: String) throws {
		let databaseQueue = try DatabaseQueue()

		let localRepository = LocalRepository(databaseQueue)
		let backendRepository = BackendRepository(
			credentialsProvider: credentialsProvider,
			installationId: installationId
		)
		let artworkDownloader = ArtworkRepository()
		let mediaDownloader = MediaDownloader(credentialsProvider: credentialsProvider)

		self.backendRepository = backendRepository
		self.localRepository = localRepository
		self.taskRunner = TaskRunner(
			backendRepository: backendRepository,
			localRepository: localRepository,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader
		)
	}

	init(
		backendRepository: BackendRepositoryProtocol,
		localRepository: LocalRepository,
		artworkDownloader: ArtworkRepositoryProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.backendRepository = backendRepository
		self.localRepository = localRepository
		self.taskRunner = TaskRunner(
			backendRepository: backendRepository,
			localRepository: localRepository,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader
		)
	}

	public func run() async throws {
		try await taskRunner.run()
	}

	// MARK: - Offline Content

	public func getOfflineMediaItem(mediaType: OfflineMediaItemType, resourceId: String) throws -> OfflineMediaItem? {
		try localRepository.getMediaItem(mediaType: mediaType, resourceId: resourceId)
	}

	public func getOfflineMediaItems(mediaType: OfflineMediaItemType) throws -> [OfflineMediaItem] {
		try localRepository.getMediaItems(mediaType: mediaType)
	}

	public func getOfflineCollection(collectionType: OfflineCollectionType, resourceId: String) throws -> OfflineCollection? {
		try localRepository.getCollection(collectionType: collectionType, resourceId: resourceId)
	}

	public func getOfflineCollections(collectionType: OfflineCollectionType) throws -> [OfflineCollection] {
		try localRepository.getCollections(collectionType: collectionType)
	}

	public func getOfflineCollectionItems(collectionType: OfflineCollectionType, resourceId: String) throws -> [OfflineCollectionItem] {
		try localRepository.getCollectionItems(collectionType: collectionType, resourceId: resourceId)
	}

	// MARK: - Download/Remove

	public func download(mediaType: OfflineMediaItemType, resourceId: String) async throws {
		try await backendRepository.addItem(type: mediaType.toResourceType, id: resourceId)
	}

	public func download(collectionType: OfflineCollectionType, resourceId: String) async throws {
		try await backendRepository.addItem(type: collectionType.toResourceType, id: resourceId)
	}

	public func remove(mediaType: OfflineMediaItemType, resourceId: String) async throws {
		try await backendRepository.removeItem(type: mediaType.toResourceType, id: resourceId)
	}

	public func remove(collectionType: OfflineCollectionType, resourceId: String) async throws {
		try await backendRepository.removeItem(type: collectionType.toResourceType, id: resourceId)
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
