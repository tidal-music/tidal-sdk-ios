import Foundation
import GRDB
import Player

// MARK: - Offliner

public final class Offliner {
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let taskRunner: TaskRunner
	private let collectionEventBroadcaster = CollectionEventBroadcaster()
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

	/// Events for every offline collection. Each access returns a new stream that receives every event emitted
	/// after it is created.
	///
	/// A `taskFinished` event is emitted after the backend has been told the task's result, so a read started from it
	/// sees the backend's new state.
	public var collectionEvents: AsyncStream<OfflineCollectionEvent> {
		collectionEventBroadcaster.stream()
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
		let databaseQueue = try OfflineStore.makeDatabaseQueue(path: OfflineStore.url().path)
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
			videoManifestFetcher: videoManifestFetcher,
			collectionEventBroadcaster: collectionEventBroadcaster
		)

		mediaDownloader.orphanedTaskHandler = { [weak self] taskId in
			guard let self, let taskId else { return }
			Task {
				try? await self.offlineApiClient.updateTask(taskId: taskId, state: .failed)
				await self.run()
			}
		}
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
			videoManifestFetcher: videoManifestFetcher,
			collectionEventBroadcaster: collectionEventBroadcaster
		)
	}

	public func run() async {
		await taskRunner.run()
	}

	// MARK: - Offline Content

	public func getOfflineMediaItem(mediaType: OfflineMediaItemType, resourceId: ResourceId) async throws -> OfflineMediaItem? {
		try await offlineStore.getMediaItem(mediaType: mediaType, resourceId: resourceId.stringValue)
	}

	public func getOfflineMediaItems(mediaType: OfflineMediaItemType) async throws -> [OfflineMediaItem] {
		let (items, failures) = try await offlineStore.getMediaItems(mediaType: mediaType)

		if !failures.isEmpty {
			Task {
				for failure in failures {
					try? await download(mediaType: failure.mediaType, resourceId: .identifier(failure.resourceId))
				}
			}
		}

		return items
	}

	public func getOfflineCollection(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) -> AsyncStream<OfflineCollection?> {
		AsyncStream { continuation in
			let task = Task {
				let local = try? await offlineStore.getCollection(
					collectionType: collectionType,
					resourceId: resourceId.stringValue
				)
				continuation.yield(local)

				if let pending = try? await offlineApiClient.getOfflineCollection(
					type: collectionType,
					id: resourceId.stringValue
				),
					let remote = try? await offlineStore.resolvePendingCollections([pending], collectionType: collectionType).first
				{
					continuation.yield(remote)
				}

				continuation.finish()
			}
			continuation.onTermination = { _ in task.cancel() }
		}
	}

	public func getOfflineCollections(
		collectionType: OfflineCollectionType,
		cursor: String? = nil
	) -> AsyncStream<Set<OfflineCollection>> {
		AsyncStream { continuation in
			let task = Task {
				let readStart = Date()
				let local = (try? await offlineStore.getCollections(collectionType: collectionType)) ?? []
				var collections = Set(local)
				continuation.yield(collections)

				var listedResourceIds: Set<String> = []
				var isComplete = cursor == nil
				var nextCursor: String? = cursor
				repeat {
					let page = try? await offlineApiClient.getPendingCollections(
						type: collectionType,
						cursor: nextCursor
					)
					if page == nil {
						isComplete = false
					}
					listedResourceIds.formUnion(page?.collections.map(\.catalogMetadata.id) ?? [])

					if let page, !page.collections.isEmpty,
					   let pending = try? await offlineStore.resolvePendingCollections(page.collections, collectionType: collectionType)
					{
						for item in pending {
							collections.update(with: item)
						}
						continuation.yield(collections)
					}

					nextCursor = page?.cursor
				} while nextCursor != nil

				if isComplete {
					try? await offlineStore.clearPendingRemovals(
						collectionType: collectionType,
						listedResourceIds: listedResourceIds,
						removedBefore: readStart
					)
				}

				continuation.finish()
			}
			continuation.onTermination = { _ in task.cancel() }
		}
	}

	/// Reads the offline collections of one type, and fails instead of returning a partial list.
	///
	/// Yields the local collections with `isComplete == false`, then the local collections merged with every
	/// pending inventory page with `isComplete == true`, then finishes. Both values are sorted by `addedAt`,
	/// newest first, then by id. A collection removed with ``remove(collectionType:resourceId:)`` is left out
	/// while the inventory still lists it as pending. Throws if the local read fails, before
	/// yielding anything, or if any inventory page fails, before yielding a complete value.
	/// A local collection whose metadata can't be read is skipped.
	public func offlineCollections(
		collectionType: OfflineCollectionType
	) -> AsyncThrowingStream<OfflineCollectionsRead, Error> {
		AsyncThrowingStream { continuation in
			let task = Task {
				do {
					let readStart = Date()
					var collections = try await offlineStore.getCollections(collectionType: collectionType).sortedByAddedAt()
					continuation.yield(OfflineCollectionsRead(collections: collections, isComplete: false))

					var listedResourceIds: Set<String> = []
					var cursor: String?
					repeat {
						let page = try await offlineApiClient.getPendingCollections(type: collectionType, cursor: cursor)
						listedResourceIds.formUnion(page.collections.map(\.catalogMetadata.id))
						let pending = try await offlineStore.resolvePendingCollections(page.collections, collectionType: collectionType)
						for item in pending {
							if let index = collections.firstIndex(of: item) {
								collections[index] = item
							} else {
								collections.append(item)
							}
						}
						cursor = page.cursor
					} while cursor != nil

					// Not fatal: an entry that isn't cleared now is cleared by a later complete read.
					try? await offlineStore.clearPendingRemovals(
						collectionType: collectionType,
						listedResourceIds: listedResourceIds,
						removedBefore: readStart
					)
					continuation.yield(OfflineCollectionsRead(collections: collections.sortedByAddedAt(), isComplete: true))
					continuation.finish()
				} catch {
					continuation.finish(throwing: error)
				}
			}
			continuation.onTermination = { _ in task.cancel() }
		}
	}

	public func getOfflineCollectionDownloadState(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) -> AsyncStream<OfflineCollectionDownloadState> {
		AsyncStream { continuation in
			let task = Task {
				let collection = OfflineCollectionReference(collectionType: collectionType, resourceId: resourceId)
				let events = await taskRunner.collectionEvents(for: collection)

				var lastState = await localDownloadState(collectionType: collectionType, resourceId: resourceId)
				continuation.yield(lastState)

				func emitBackendStateIfChanged() async {
					if let state = await backendDownloadState(collectionType: collectionType, resourceId: resourceId), state != lastState {
						lastState = state
						continuation.yield(state)
					}
				}

				await emitBackendStateIfChanged()

				for await _ in events {
					await emitBackendStateIfChanged()
				}

				continuation.finish()
			}
			continuation.onTermination = { _ in task.cancel() }
		}
	}

	public func countOfflineCollectionItems(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) async throws -> Int {
		try await offlineStore.countCollectionItems(collectionType: collectionType, resourceId: resourceId.stringValue)
	}

	public func getOfflineCollectionItems(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId,
		limit: Int,
		sort: OfflineCollectionItemSort? = nil,
		after cursor: String? = nil
	) async throws -> OfflineCollectionItemsPage {
		let resourceId = resourceId.stringValue

		let (page, failures): (OfflineCollectionItemsPage, [FailedOfflineItem])
		switch sort {
		case nil:
			(page, failures) = try await offlineStore.getCollectionItems(
				collectionType: collectionType,
				resourceId: resourceId,
				limit: limit,
				after: cursor
			)
		case .title(let direction):
			(page, failures) = try await offlineStore.getCollectionItemsOrderByTitle(
				collectionType: collectionType,
				resourceId: resourceId,
				direction: direction,
				limit: limit,
				after: cursor
			)
		case .album(let direction):
			(page, failures) = try await offlineStore.getCollectionItemsOrderByAlbum(
				collectionType: collectionType,
				resourceId: resourceId,
				direction: direction,
				limit: limit,
				after: cursor
			)
		case .artist(let direction):
			(page, failures) = try await offlineStore.getCollectionItemsOrderByArtist(
				collectionType: collectionType,
				resourceId: resourceId,
				direction: direction,
				limit: limit,
				after: cursor
			)
		case .dateAdded(let direction):
			(page, failures) = try await offlineStore.getCollectionItemsOrderByDateAdded(
				collectionType: collectionType,
				resourceId: resourceId,
				direction: direction,
				limit: limit,
				after: cursor
			)
		}

		scheduleRedownload(for: failures)
		return page
	}

	public func findInOfflineCollection(
		search: String,
		collectionType: OfflineCollectionType,
		resourceId: ResourceId,
		sort: OfflineCollectionItemSort? = nil,
		limit: Int = 20,
		after cursor: String? = nil
	) async throws -> OfflineCollectionSearchPage {
		let (page, failures) = try await offlineStore.searchCollectionItems(
			collectionType: collectionType,
			resourceId: resourceId.stringValue,
			query: search,
			sort: sort,
			limit: limit,
			after: cursor
		)

		scheduleRedownload(for: failures)
		return page
	}

	private func scheduleRedownload(for failures: [FailedOfflineItem]) {
		guard !failures.isEmpty else { return }
		Task {
			for failure in failures {
				try? await download(mediaType: failure.mediaType, resourceId: .identifier(failure.resourceId))
			}
		}
	}

	public func getAudioFormatOfCollection(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) async throws -> AudioFormat? {
		try await offlineStore.getAudioFormatOfCollection(collectionType: collectionType, resourceId: resourceId.stringValue)
	}

	public func getCollectionDuration(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) async throws -> Int {
		try await offlineStore.getCollectionDuration(collectionType: collectionType, resourceId: resourceId.stringValue)
	}

	// MARK: - Download/Remove

	public func download(mediaType: OfflineMediaItemType, resourceId: ResourceId) async throws {
		try await offlineApiClient.addItem(type: mediaType.toResourceType, id: resourceId.stringValue)
		await taskRunner.run()
	}

	public func download(collectionType: OfflineCollectionType, resourceId: ResourceId) async throws {
		try await offlineApiClient.addItem(type: collectionType.toResourceType, id: resourceId.stringValue)
		try offlineStore.clearPendingRemoval(OfflineCollectionReference(collectionType: collectionType, resourceId: resourceId))
		// Not fatal: storing the collection records its addedAt if this fails.
		try? offlineStore.recordCollectionAddedAt(collectionType: collectionType, resourceId: resourceId.stringValue, addedAt: Date())
		collectionEventBroadcaster.emit(OfflineCollectionEvent(
			collection: OfflineCollectionReference(collectionType: collectionType, resourceId: resourceId),
			kind: .requested
		))
		await taskRunner.notifyCollectionChanged(collectionType: collectionType, resourceId: resourceId)
		await taskRunner.run()
	}

	public func remove(mediaType: OfflineMediaItemType, resourceId: ResourceId) async throws {
		try await offlineApiClient.removeItem(type: mediaType.toResourceType, id: resourceId.stringValue)
		await taskRunner.run()
	}

	/// Removes a collection. After this returns, local reads no longer contain it, and pending inventory reads
	/// leave it out until the backend stops listing it. Throws if the backend request or the local delete fails.
	///
	/// Queued downloads of the collection are cancelled, and finish as ``Download/State/failed``.
	public func remove(collectionType: OfflineCollectionType, resourceId: ResourceId) async throws {
		try await offlineApiClient.removeItem(type: collectionType.toResourceType, id: resourceId.stringValue)

		let collection = OfflineCollectionReference(collectionType: collectionType, resourceId: resourceId)
		// Optimistically update local availability; the remove task performs the same idempotent cleanup.
		let localDelete = Result {
			try offlineStore.deleteCollection(
				resourceType: collectionType.rawValue,
				resourceId: collection.resourceId,
				markPendingRemoval: true
			)
		}
		await taskRunner.cancelTasks(for: collection)
		collectionEventBroadcaster.emit(OfflineCollectionEvent(collection: collection, kind: .removed))
		await taskRunner.notifyCollectionChanged(collectionType: collectionType, resourceId: resourceId)
		await taskRunner.run()

		try localDelete.get()
	}

	private func localDownloadState(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) async -> OfflineCollectionDownloadState {
		let localCollection = try? await offlineStore.getCollection(
			collectionType: collectionType,
			resourceId: collectionLocalResourceId(collectionType: collectionType, resourceId: resourceId)
		)

		return localCollection == nil ? .notDownloaded : .downloaded
	}

	private func backendDownloadState(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) async -> OfflineCollectionDownloadState? {
		do {
			let pendingCollection = try await offlineApiClient.getOfflineCollection(
				type: collectionType,
				id: resourceId.stringValue
			)
			var isPending = false
			if let pendingCollection {
				isPending = try await !offlineStore.resolvePendingCollections([pendingCollection], collectionType: collectionType).isEmpty
			}

			return !isPending
				? await localDownloadState(collectionType: collectionType, resourceId: resourceId)
				: .downloading
		} catch {
			return nil
		}
	}

	private func collectionLocalResourceId(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) -> String {
		collectionType == .userCollectionTracks ? ResourceId.me.stringValue : resourceId.stringValue
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
			return try await offlineStore.getPlayableMediaItem(mediaType: mediaType, resourceId: productId)
				.map { OfflinePlaybackItem($0, productType: productType) }
		} catch {
			Task { try? await download(mediaType: mediaType, resourceId: .identifier(productId)) }
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
		case .userCollectionTracks: return .userCollectionTracks
		}
	}
}

extension [OfflineCollection] {
	/// Newest first. Collections added at the same time are ordered by id, so the order is the same on every read.
	func sortedByAddedAt() -> [OfflineCollection] {
		sorted { lhs, rhs in
			lhs.addedAt == rhs.addedAt ? lhs.catalogMetadata.id < rhs.catalogMetadata.id : lhs.addedAt > rhs.addedAt
		}
	}
}

// MARK: - OfflinePlaybackItem from PlayableOfflineMediaItem

private extension OfflinePlaybackItem {
	init(_ item: PlayableOfflineMediaItem, productType: ProductType) {
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
