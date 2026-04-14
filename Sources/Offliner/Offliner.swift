import Foundation
import GRDB
import Player

// MARK: - Offliner

public final class Offliner {
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let taskRunner: TaskRunner
	private let mediaDownloader: MediaDownloaderProtocol
	private var trackManifestFetcher: TrackManifestFetcherProtocol

	public var audioFormats: [AudioFormat] {
		didSet {
			trackManifestFetcher.audioFormats = audioFormats
		}
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

	public func handleBackgroundURLSessionEvents(identifier: String, completionHandler: @escaping () -> Void) {
		mediaDownloader.handleBackgroundURLSessionEvents(identifier: identifier, completionHandler: completionHandler)
	}

	public init(installationId: String, configuration: Configuration) throws {
		let databaseQueue = try DatabaseQueue(path: OfflineStore.url().path)
		try Migrations.run(databaseQueue)

		let offlineStore = OfflineStore(databaseQueue)
		let offlineApiClient = OfflineApiClient(installationId: installationId)
		let artworkDownloader = ArtworkDownloader()
		let mediaDownloader = MediaDownloader(configuration: configuration)
		let licenseDownloader = LicenseDownloader()
		let trackManifestFetcher = TrackManifestFetcher(audioFormats: configuration.audioFormats)
		let videoManifestFetcher = VideoManifestFetcher()

		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.mediaDownloader = mediaDownloader
		self.trackManifestFetcher = trackManifestFetcher
		self.audioFormats = configuration.audioFormats
		self.taskRunner = TaskRunner(
			configuration: configuration,
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			licenseDownloader: licenseDownloader,
			trackManifestFetcher: trackManifestFetcher,
			videoManifestFetcher: videoManifestFetcher
		)
	}

	init(
		configuration: Configuration = Configuration(),
		offlineApiClient: OfflineApiClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		licenseDownloader: LicenseDownloader = LicenseDownloader(),
		trackManifestFetcher: TrackManifestFetcherProtocol,
		videoManifestFetcher: VideoManifestFetcherProtocol
	) {
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.mediaDownloader = mediaDownloader
		self.trackManifestFetcher = trackManifestFetcher
		self.audioFormats = configuration.audioFormats
		self.taskRunner = TaskRunner(
			configuration: configuration,
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			licenseDownloader: licenseDownloader,
			trackManifestFetcher: trackManifestFetcher,
			videoManifestFetcher: videoManifestFetcher
		)
	}

	public func run() async {
		await taskRunner.run()
	}

	// MARK: - Offline Content

	public func getOfflineMediaItem(mediaType: OfflineMediaItemType, resourceId: String) async throws -> OfflineMediaItem? {
		try await offlineStore.getMediaItem(mediaType: mediaType, resourceId: resourceId)
	}

	public func getOfflineMediaItems(mediaType: OfflineMediaItemType) async throws -> [OfflineMediaItem] {
		let (items, failures) = try await offlineStore.getMediaItems(mediaType: mediaType)

		if !failures.isEmpty {
			Task {
				for failure in failures {
					try? await download(mediaType: failure.mediaType, resourceId: failure.resourceId)
				}
			}
		}

		return items
	}

	public func getOfflineCollection(
		collectionType: OfflineCollectionType,
		resourceId: String
	) async throws -> OfflineCollection? {
		try await offlineStore.getCollection(collectionType: collectionType.toInternal, resourceId: resourceId)
	}

	public func getOfflineCollections(collectionType: OfflineCollectionType) async throws -> [OfflineCollection] {
		try await offlineStore.getCollections(collectionType: collectionType.toInternal)
	}

	public func countOfflineCollectionItems(
		collectionType: OfflineCollectionType,
		resourceId: String
	) async throws -> Int {
		try await offlineStore.countCollectionItems(collectionType: collectionType.toInternal, resourceId: resourceId)
	}

	public func getOfflineCollectionItems(
		collectionType: OfflineCollectionType,
		resourceId: String,
		limit: Int,
		after cursor: Int64? = nil
	) async throws -> OfflineCollectionItemsPage {
		let (page, failures) = try await offlineStore.getCollectionItems(
			collectionType: collectionType.toInternal,
			resourceId: resourceId,
			limit: limit,
			after: cursor
		)

		if !failures.isEmpty {
			Task {
				for failure in failures {
					try? await download(mediaType: failure.mediaType, resourceId: failure.resourceId)
				}
			}
		}

		return page
	}

	public func getAudioFormatOfCollection(
		collectionType: OfflineCollectionType,
		resourceId: String
	) async throws -> AudioFormat? {
		try await offlineStore.getAudioFormatOfCollection(collectionType: collectionType.toInternal, resourceId: resourceId)
	}

	public func getCollectionDuration(
		collectionType: OfflineCollectionType,
		resourceId: String
	) async throws -> Int {
		try await offlineStore.getCollectionDuration(collectionType: collectionType.toInternal, resourceId: resourceId)
	}

	// MARK: - Download/Remove

	public func download(mediaType: OfflineMediaItemType, resourceId: String) async throws {
		try await offlineApiClient.addItem(type: mediaType.toResourceType, id: resourceId)
		await taskRunner.run()
	}

	public func download(collectionType: OfflineCollectionType, resourceId: String) async throws {
		try await offlineApiClient.addItem(type: collectionType.toResourceType, id: resourceId)
		await taskRunner.run()
	}

	public func remove(mediaType: OfflineMediaItemType, resourceId: String) async throws {
		try await offlineApiClient.removeItem(type: mediaType.toResourceType, id: resourceId)
		await taskRunner.run()
	}

	public func remove(collectionType: OfflineCollectionType, resourceId: String) async throws {
		try await offlineApiClient.removeItem(type: collectionType.toResourceType, id: resourceId)
		await taskRunner.run()
	}

	public func downloadUserCollectionTracks() async throws {
		try await offlineApiClient.addItem(type: .userCollectionTracks, id: "me")
		await taskRunner.run()
	}

	public func removeUserCollectionTracks() async throws {
		try await offlineApiClient.removeItem(type: .userCollectionTracks, id: "me")
		await taskRunner.run()
	}

}

// MARK: - OfflineItemProvider

extension Offliner: OfflineItemProvider {
	public func get(productType: ProductType, productId: String) async -> OfflinePlaybackItem? {
		let mediaType: OfflineMediaItemType
		switch productType {
		case .TRACK: mediaType = .tracks
		case .VIDEO: mediaType = .videos
		case .UC: return nil
		}

		do {
			return try await offlineStore.getMediaItem(mediaType: mediaType, resourceId: productId)
				.map { OfflinePlaybackItem($0, productType: productType) }
		} catch {
			Task { try? await download(mediaType: mediaType, resourceId: productId) }
		}

		return nil
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

	var toInternal: OfflineCollectionTypeInternal {
		switch self {
		case .albums: return .albums
		case .playlists: return .playlists
		}
	}
}

enum OfflineCollectionTypeInternal: String {
	case albums
	case playlists
	case userCollectionTracks
}

// MARK: - OfflinePlaybackItem from OfflineMediaItem

private extension OfflinePlaybackItem {
	init(_ item: OfflineMediaItem, productType: ProductType) {
		self.init(
			mediaURL: item.mediaURL,
			licenseURL: item.licenseURL,
			format: item.playbackMetadata?.format.rawValue,
			albumReplayGain: item.playbackMetadata?.albumNormalizationData?.replayGain,
			albumPeakAmplitude: item.playbackMetadata?.albumNormalizationData?.peakAmplitude,
			productType: productType
		)
	}
}
