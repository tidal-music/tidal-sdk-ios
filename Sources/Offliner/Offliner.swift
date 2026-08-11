import Foundation
import GRDB

// MARK: - Offliner

public final class Offliner {
	static let defaultCollectionPollInterval: UInt64 = 1_000_000_000

	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let storage: OfflinerStorage
	private let taskRunner: TaskRunner
	private let mediaDownloader: MediaDownloaderProtocol
	private let collectionDownloadStatePollInterval: UInt64
	private var trackManifestFetcher: TrackManifestFetcherProtocol
	private let lifecycleLock = NSLock()
	private var isReset = false
	private var resetTask: Task<Void, Error>?

	public var audioFormats: [AudioFormat] {
		didSet {
			trackManifestFetcher.audioFormats = audioFormats
		}
	}

	public func setAllowDownloadsOnExpensiveNetworks(_ allowed: Bool) async {
		guard isActive else { return }
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
		guard isActive else { return }
		mediaDownloader.handleBackgroundURLSessionEvents(identifier: identifier, completionHandler: completionHandler)
	}

	public init(installationId: String, configuration: Configuration) throws {
		let storage = try OfflinerStorage(installationId: installationId)
		let offlineStore = storage.offlineStore
		let offlineApiClient = OfflineApiClient(installationId: installationId)
		let artworkDownloader = ArtworkDownloader(fileStorage: storage.fileStorage)
		let mediaDownloader = MediaDownloader(
			configuration: configuration,
			backgroundSessionIdentifier: storage.backgroundSessionIdentifier
		)
		let licenseDownloader = LicenseDownloader(fileStorage: storage.fileStorage)
		let trackManifestFetcher = TrackManifestFetcher(audioFormats: configuration.audioFormats)
		let videoManifestFetcher = VideoManifestFetcher()

		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.storage = storage
		self.mediaDownloader = mediaDownloader
		self.collectionDownloadStatePollInterval = Self.defaultCollectionPollInterval
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

		mediaDownloader.orphanedTaskHandler = { [weak self] taskId in
			guard let self, self.isActive, let taskId else { return }
			Task {
				guard self.isActive else { return }
				try? await self.offlineApiClient.updateTask(taskId: taskId, state: .failed)
				guard self.isActive else { return }
				await self.run()
			}
		}
	}

	init(
		configuration: Configuration = Configuration(),
		storage: OfflinerStorage,
		offlineApiClient: OfflineApiClientProtocol,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		licenseDownloader: LicenseDownloader? = nil,
		trackManifestFetcher: TrackManifestFetcherProtocol,
		videoManifestFetcher: VideoManifestFetcherProtocol,
		collectionDownloadStatePollInterval: UInt64 = Offliner.defaultCollectionPollInterval
	) {
		let offlineStore = storage.offlineStore
		let licenseDownloader = licenseDownloader ?? LicenseDownloader(fileStorage: storage.fileStorage)
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.storage = storage
		self.mediaDownloader = mediaDownloader
		self.collectionDownloadStatePollInterval = collectionDownloadStatePollInterval
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
		guard isActive else { return }
		await taskRunner.run()
	}

	/// Permanently invalidates this instance and removes only its installation-scoped local offline data.
	///
	/// This operation does not enqueue backend removals. Create a new `Offliner` after reset, including when signing in again
	/// with the same installation identifier.
	public func reset() async throws {
		try await resetOperation().value
	}

	private func resetOperation() -> Task<Void, Error> {
		lifecycleLock.lock()
		defer { lifecycleLock.unlock() }
		if let resetTask {
			return resetTask
		}

		isReset = true
		storage.invalidateWrites()
		let task = Task { [taskRunner, storage] in
			await taskRunner.shutdown()
			try storage.reset()
		}
		resetTask = task
		return task
	}

	// MARK: - Offline Content

	public func getOfflineMediaItem(mediaType: OfflineMediaItemType, resourceId: ResourceId) async throws -> OfflineMediaItem? {
		try ensureActive()
		return try await offlineStore.getMediaItem(mediaType: mediaType, resourceId: resourceId.stringValue)
	}

	public func getOfflineMediaItems(mediaType: OfflineMediaItemType) async throws -> [OfflineMediaItem] {
		try ensureActive()
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

	/// Returns the locally playable asset for an offlined track or video.
	///
	/// File bookmarks are resolved only for playback so enumerating offline content remains fast. If a stored file can no
	/// longer be resolved, the item is scheduled for download again and this method returns `nil`.
	public func getOfflinePlaybackAsset(
		mediaType: OfflineMediaItemType,
		resourceId: ResourceId
	) async -> OfflinePlaybackAsset? {
		guard isActive else { return nil }
		do {
			return try await offlineStore.getPlaybackAsset(mediaType: mediaType, resourceId: resourceId.stringValue)
		} catch {
			Task { try? await download(mediaType: mediaType, resourceId: resourceId) }
			return nil
		}
	}

	public func getOfflineCollection(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) -> AsyncStream<OfflineCollection?> {
		guard isActive else { return AsyncStream { $0.finish() } }
		return AsyncStream { continuation in
			let task = Task {
				let local = try? await offlineStore.getCollection(
					collectionType: collectionType,
					resourceId: resourceId.stringValue
				)
				continuation.yield(local)

				if let remote = try? await offlineApiClient.getOfflineCollection(
					type: collectionType,
					id: resourceId.stringValue
				) {
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
		guard isActive else { return AsyncStream { $0.finish() } }
		return AsyncStream { continuation in
			let task = Task {
				let local = (try? await offlineStore.getCollections(collectionType: collectionType)) ?? []
				var collections = Set(local)
				continuation.yield(collections)

				var nextCursor: String? = cursor
				repeat {
					let page = try? await offlineApiClient.getPendingCollections(
						type: collectionType,
						cursor: nextCursor
					)

					if let page, !page.collections.isEmpty {
						for item in page.collections {
							collections.update(with: item)
						}
						continuation.yield(collections)
					}

					nextCursor = page?.cursor
				} while nextCursor != nil

				continuation.finish()
			}
			continuation.onTermination = { _ in task.cancel() }
		}
	}

	/// Returns a finite, error-preserving snapshot of locally stored collections.
	///
	/// This method does not access the network, so stored content remains available while offline.
	public func getStoredOfflineCollections(
		collectionType: OfflineCollectionType
	) async throws -> Set<OfflineCollection> {
		try ensureActive()
		return Set(try await offlineStore.getCollections(collectionType: collectionType))
	}

	/// Streams collection-level offline availability.
	///
	/// The stream emits a fast initial value from local storage and active in-memory downloads, then continues polling for
	/// later local changes.
	///
	/// The stream does not poll backend task inventory. Removal is represented as `.notDownloaded`; `.downloading` is
	/// reserved for active download/acquisition work already known by this SDK instance.
	public func getOfflineCollectionDownloadState(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) -> AsyncStream<OfflineCollectionDownloadState> {
		guard isActive else { return AsyncStream { $0.finish() } }
		return AsyncStream { continuation in
			let task = Task {
				var lastState: OfflineCollectionDownloadState?
				var consecutiveDownloadedObservations = 0

				func yieldState(_ state: OfflineCollectionDownloadState) {
					let shouldYield: Bool

					// A second downloaded observation avoids transient completion between collection metadata and
					// collection item tasks.
					if state == .downloaded {
						consecutiveDownloadedObservations += 1
						shouldYield = lastState == .downloaded || consecutiveDownloadedObservations >= 2
					} else {
						consecutiveDownloadedObservations = 0
						shouldYield = true
					}

					if shouldYield, state != lastState {
						continuation.yield(state)
						lastState = state
					}
				}

				let initialState = await offlineCollectionDownloadState(
					collectionType: collectionType,
					resourceId: resourceId
				)
				continuation.yield(initialState)
				lastState = initialState

				while !Task.isCancelled {
					try? await Task.sleep(nanoseconds: collectionDownloadStatePollInterval)
					guard !Task.isCancelled else { break }

					let state = await offlineCollectionDownloadState(
						collectionType: collectionType,
						resourceId: resourceId
					)

					yieldState(state)
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
		try ensureActive()
		return try await offlineStore.countCollectionItems(collectionType: collectionType, resourceId: resourceId.stringValue)
	}

	public func getOfflineCollectionItems(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId,
		limit: Int,
		sort: OfflineCollectionItemSort? = nil,
		after cursor: String? = nil
	) async throws -> OfflineCollectionItemsPage {
		try ensureActive()
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
		try ensureActive()
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
		try ensureActive()
		return try await offlineStore.getAudioFormatOfCollection(collectionType: collectionType, resourceId: resourceId.stringValue)
	}

	public func getCollectionDuration(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) async throws -> Int {
		try ensureActive()
		return try await offlineStore.getCollectionDuration(collectionType: collectionType, resourceId: resourceId.stringValue)
	}

	// MARK: - Download/Remove

	public func download(mediaType: OfflineMediaItemType, resourceId: ResourceId) async throws {
		try ensureActive()
		try await offlineApiClient.addItem(type: mediaType.toResourceType, id: resourceId.stringValue)
		await taskRunner.run()
	}

	public func download(collectionType: OfflineCollectionType, resourceId: ResourceId) async throws {
		try ensureActive()
		try await offlineApiClient.addItem(type: collectionType.toResourceType, id: resourceId.stringValue)
		await taskRunner.run()
	}

	public func remove(mediaType: OfflineMediaItemType, resourceId: ResourceId) async throws {
		try ensureActive()
		try await offlineApiClient.removeItem(type: mediaType.toResourceType, id: resourceId.stringValue)
		await taskRunner.run()
	}

	public func remove(collectionType: OfflineCollectionType, resourceId: ResourceId) async throws {
		try ensureActive()
		try await offlineApiClient.removeItem(type: collectionType.toResourceType, id: resourceId.stringValue)
		// Optimistically update local availability; the remove task performs the same idempotent cleanup.
		try? offlineStore.deleteCollection(
			resourceType: collectionType.rawValue,
			resourceId: collectionLocalResourceId(collectionType: collectionType, resourceId: resourceId)
		)
		await taskRunner.run()
	}

	private func offlineCollectionDownloadState(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) async -> OfflineCollectionDownloadState {
		if await taskRunner.hasCurrentDownload(relatedTo: collectionType, resourceId: resourceId) {
			return .downloading
		}

		let localCollection = try? await offlineStore.getCollection(
			collectionType: collectionType,
			resourceId: collectionLocalResourceId(collectionType: collectionType, resourceId: resourceId)
		)

		return localCollection == nil ? .notDownloaded : .downloaded
	}

	private func collectionLocalResourceId(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) -> String {
		collectionType == .userCollectionTracks ? ResourceId.me.stringValue : resourceId.stringValue
	}

	private var isActive: Bool {
		lifecycleLock.lock()
		defer { lifecycleLock.unlock() }
		return !isReset
	}

	private func ensureActive() throws {
		guard isActive else { throw OfflinerLifecycleError.reset }
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
