import Foundation
import GRDB
import Player

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
		public let id: String
		public let title: String
		public let artists: [String]
		public let duration: String
	}

	public struct VideoMetadata: Codable {
		public let id: String
		public let title: String
		public let artists: [String]
		public let duration: String
	}

	public enum Metadata {
		case track(TrackMetadata)
		case video(VideoMetadata)

		public var id: String {
			switch self {
			case .track(let metadata): return metadata.id
			case .video(let metadata): return metadata.id
			}
		}
	}

	public let metadata: Metadata
	public let mediaURL: URL
	public let licenseURL: URL?
	public let artworkURL: URL?
}

public struct OfflineCollection {
	public struct AlbumMetadata: Codable {
		public let id: String
		public let title: String
		public let artists: [String]
		public let copyright: String?
	}

	public struct PlaylistMetadata: Codable {
		public let id: String
		public let title: String
	}

	public enum Metadata {
		case album(AlbumMetadata)
		case playlist(PlaylistMetadata)

		public var id: String {
			switch self {
			case .album(let metadata): return metadata.id
			case .playlist(let metadata): return metadata.id
			}
		}
	}

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
		try await taskRunner.run()
	}

	public func download(collectionType: OfflineCollectionType, resourceId: String) async throws {
		try await backendClient.addItem(type: collectionType.toResourceType, id: resourceId)
		try await taskRunner.run()
	}

	public func remove(mediaType: OfflineMediaItemType, resourceId: String) async throws {
		try await backendClient.removeItem(type: mediaType.toResourceType, id: resourceId)
		try await taskRunner.run()
	}

	public func remove(collectionType: OfflineCollectionType, resourceId: String) async throws {
		try await backendClient.removeItem(type: collectionType.toResourceType, id: resourceId)
		try await taskRunner.run()
	}
}

// MARK: - OfflineItemProvider

extension Offliner: OfflineItemProvider {
	public func get(productType: ProductType, productId: String) throws -> OfflinePlaybackItem? {
		let mediaType: OfflineMediaItemType
		switch productType {
		case .TRACK: mediaType = .tracks
		case .VIDEO: mediaType = .videos
		case .UC: return nil
		}

		guard let item = try getOfflineMediaItem(mediaType: mediaType, resourceId: productId) else {
			return nil
		}

		return OfflinePlaybackItem(
			mediaURL: item.mediaURL,
			licenseURL: item.licenseURL,
			format: "HEAACV1",
			albumReplayGain: nil,
			albumPeakAmplitude: nil
		)
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
