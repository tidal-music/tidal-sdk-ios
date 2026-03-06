import Foundation
import GRDB
import Player

// MARK: - Offliner

public final class Offliner {
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let taskRunner: TaskRunner
	private var mediaDownloader: MediaDownloaderProtocol

	public var audioFormats: [AudioFormat] {
		get { mediaDownloader.audioFormats }
		set { mediaDownloader.audioFormats = newValue }
	}

	public func setAllowDownloadsOnExpensiveNetworks(_ allowed: Bool) async {
		await taskRunner.setAllowDownloadsOnExpensiveNetworks(allowed)
	}

	public var newDownloads: AsyncStream<Download> {
		taskRunner.newDownloads
	}

	public var currentDownloads: [Download] {
		get async {
			await taskRunner.currentDownloads
		}
	}

	public init(installationId: String, configuration: Configuration) throws {
		let databaseQueue = try DatabaseQueue(path: OfflineStore.url().path)
		try Migrations.run(databaseQueue)

		let offlineStore = OfflineStore(databaseQueue)
		let offlineApiClient = OfflineApiClient(installationId: installationId)
		let artworkDownloader = ArtworkDownloader()
		let mediaDownloader = MediaDownloader(configuration: configuration)

		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.mediaDownloader = mediaDownloader
		self.taskRunner = TaskRunner(
			configuration: configuration,
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader
		)
	}

	init(
		configuration: Configuration = Configuration(),
		offlineApiClient: OfflineApiClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.mediaDownloader = mediaDownloader
		self.taskRunner = TaskRunner(
			configuration: configuration,
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader
		)
	}

	public func run() async throws {
		try await taskRunner.run()
	}

	// MARK: - Offline Content

	public func getOfflineMediaItem(mediaType: OfflineMediaItemType, resourceId: String) async throws -> OfflineMediaItem? {
		try await offlineStore.getMediaItem(mediaType: mediaType, resourceId: resourceId)
	}

	public func getOfflineMediaItems(mediaType: OfflineMediaItemType) async throws -> [OfflineMediaItem] {
		try await offlineStore.getMediaItems(mediaType: mediaType)
	}

	public func getOfflineCollection(
		collectionType: OfflineCollectionType,
		resourceId: String
	) async throws -> OfflineCollection? {
		try await offlineStore.getCollection(collectionType: collectionType, resourceId: resourceId)
	}

	public func getOfflineCollections(collectionType: OfflineCollectionType) async throws -> [OfflineCollection] {
		try await offlineStore.getCollections(collectionType: collectionType)
	}

	public func countOfflineCollectionItems(
		collectionType: OfflineCollectionType,
		resourceId: String
	) async throws -> Int {
		try await offlineStore.countCollectionItems(collectionType: collectionType, resourceId: resourceId)
	}

	public func getOfflineCollectionItems(
		collectionType: OfflineCollectionType,
		resourceId: String,
		limit: Int,
		after cursor: Int64? = nil
	) async throws -> OfflineCollectionItemsPage {
		try await offlineStore.getCollectionItems(
			collectionType: collectionType,
			resourceId: resourceId,
			limit: limit,
			after: cursor
		)
	}

	public func getAudioFormatOfCollection(
		collectionType: OfflineCollectionType,
		resourceId: String
	) async throws -> AudioFormat? {
		try await offlineStore.getAudioFormatOfCollection(collectionType: collectionType, resourceId: resourceId)
	}

	public func getCollectionDuration(
		collectionType: OfflineCollectionType,
		resourceId: String
	) async throws -> Int {
		try await offlineStore.getCollectionDuration(collectionType: collectionType, resourceId: resourceId)
	}

	// MARK: - Download/Remove

	public func download(mediaType: OfflineMediaItemType, resourceId: String) async throws {
		try await offlineApiClient.addItem(type: mediaType.toResourceType, id: resourceId)
		try await taskRunner.run()
	}

	public func download(collectionType: OfflineCollectionType, resourceId: String) async throws {
		try await offlineApiClient.addItem(type: collectionType.toResourceType, id: resourceId)
		try await taskRunner.run()
	}

	public func remove(mediaType: OfflineMediaItemType, resourceId: String) async throws {
		try await offlineApiClient.removeItem(type: mediaType.toResourceType, id: resourceId)
		try await taskRunner.run()
	}

	public func remove(collectionType: OfflineCollectionType, resourceId: String) async throws {
		try await offlineApiClient.removeItem(type: collectionType.toResourceType, id: resourceId)
		try await taskRunner.run()
	}
}

// MARK: - OfflineItemProvider

extension Offliner: OfflineItemProvider {
	public func get(productType: ProductType, productId: String) async throws -> OfflinePlaybackItem? {
		let mediaType: OfflineMediaItemType
		switch productType {
		case .TRACK: mediaType = .tracks
		case .VIDEO: mediaType = .videos
		case .UC: return nil
		}

		guard let item = try await offlineStore.getMediaItem(mediaType: mediaType, resourceId: productId) else {
			return nil
		}

		return OfflinePlaybackItem(
			mediaURL: item.mediaURL,
			licenseURL: item.licenseURL,
			format: item.playbackMetadata?.format.rawValue,
			albumReplayGain: item.playbackMetadata?.albumNormalizationData?.replayGain,
			albumPeakAmplitude: item.playbackMetadata?.albumNormalizationData?.peakAmplitude
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
		case .userCollectionTracks: return .userCollectionTracks
		}
	}
}
