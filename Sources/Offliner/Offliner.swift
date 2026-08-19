import Foundation
import GRDB

// MARK: - Offliner

public final class Offliner {
	static let defaultCollectionDownloadStatePollInterval: UInt64 = 1_000_000_000

	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let storage: OfflinerStorage
	private let taskRunner: TaskRunner
	private let mediaDownloader: MediaDownloaderProtocol
	private let resourceStateTracker: ResourceStateTracker
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
		guard isActive else {
			return
		}
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

	@discardableResult
	public func handleBackgroundURLSessionEvents(identifier: String, completionHandler: @escaping () -> Void) -> Bool {
		guard isActive else {
			return false
		}
		return mediaDownloader.handleBackgroundURLSessionEvents(
			identifier: identifier,
			completionHandler: completionHandler
		)
	}

	public init(installationId: String, configuration: Configuration) throws {
		let storage = try OfflinerStorage(installationId: installationId)
		let offlineStore = storage.offlineStore
		let offlineApiClient = OfflineApiClient(installationId: installationId)
		let artworkDownloader = ArtworkDownloader(fileStorage: storage.fileStorage)
		let mediaDownloader = MediaDownloader(
			configuration: configuration,
			backgroundSessionIdentifier: storage.backgroundSessionIdentifier,
			fileStorage: storage.fileStorage
		)
		let licenseDownloader = LicenseDownloader(fileStorage: storage.fileStorage)
		let resourceStateTracker = ResourceStateTracker(offlineStore: offlineStore)
		let trackManifestFetcher = TrackManifestFetcher(audioFormats: configuration.audioFormats)
		let videoManifestFetcher = VideoManifestFetcher()

		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.storage = storage
		self.mediaDownloader = mediaDownloader
		self.resourceStateTracker = resourceStateTracker
		collectionDownloadStatePollInterval = Self.defaultCollectionDownloadStatePollInterval
		self.trackManifestFetcher = trackManifestFetcher
		audioFormats = configuration.audioFormats
		taskRunner = TaskRunner(
			configuration: configuration,
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			licenseDownloader: licenseDownloader,
			resourceStateTracker: resourceStateTracker,
			trackManifestFetcher: trackManifestFetcher,
			videoManifestFetcher: videoManifestFetcher
		)

		mediaDownloader.orphanedTaskHandler = { [weak self] taskId in
			guard let self, isActive, let taskId else {
				return
			}
			Task {
				guard self.isActive else {
					return
				}
				try? await self.offlineApiClient.updateTask(taskId: taskId, state: .failed)
				guard self.isActive else {
					return
				}
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
		collectionDownloadStatePollInterval: UInt64 = Offliner.defaultCollectionDownloadStatePollInterval
	) {
		let offlineStore = storage.offlineStore
		let licenseDownloader = licenseDownloader ?? LicenseDownloader(fileStorage: storage.fileStorage)
		let resourceStateTracker = ResourceStateTracker(offlineStore: offlineStore)
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.storage = storage
		self.mediaDownloader = mediaDownloader
		self.resourceStateTracker = resourceStateTracker
		self.collectionDownloadStatePollInterval = collectionDownloadStatePollInterval
		self.trackManifestFetcher = trackManifestFetcher
		audioFormats = configuration.audioFormats
		taskRunner = TaskRunner(
			configuration: configuration,
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			licenseDownloader: licenseDownloader,
			resourceStateTracker: resourceStateTracker,
			trackManifestFetcher: trackManifestFetcher,
			videoManifestFetcher: videoManifestFetcher
		)
	}

	public func run() async {
		guard isActive else {
			return
		}
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
	/// longer be resolved, this method returns `nil`.
	public func getOfflinePlaybackAsset(
		mediaType: OfflineMediaItemType,
		resourceId: ResourceId
	) async -> OfflinePlaybackAsset? {
		guard isActive else {
			return nil
		}
		return try? await offlineStore.getPlaybackAsset(mediaType: mediaType, resourceId: resourceId.stringValue)
	}

	/// Returns an AVFoundation asset prepared for unprotected or stored-license playback.
	///
	/// Retain the returned object for the entire lifetime of every `AVPlayerItem` made from its `urlAsset`, including while
	/// queued. If stored playback files or license preparation cannot be resolved, this returns `nil`.
	public func getOfflinePlaybackAVAsset(
		mediaType: OfflineMediaItemType,
		resourceId: ResourceId
	) async -> OfflinePlaybackAVAsset? {
		guard let playbackAsset = await getOfflinePlaybackAsset(mediaType: mediaType, resourceId: resourceId) else {
			return nil
		}
		return try? OfflinePlaybackAVAsset(playbackAsset: playbackAsset)
	}

	public func getOfflineCollection(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) -> AsyncStream<OfflineCollection?> {
		guard isActive else {
			return AsyncStream { $0.finish() }
		}
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
		guard isActive else {
			return AsyncStream { $0.finish() }
		}
		return AsyncStream { continuation in
			let task = Task {
				let local = await (try? offlineStore.getCollections(collectionType: collectionType)) ?? []
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
		return try await Set(offlineStore.getCollections(collectionType: collectionType))
	}

	/// Returns the latest operation or local availability state for a media item or collection.
	///
	/// Locally persisted queued, removing, and failed operations survive Offliner recreation. A backend refresh is scheduled
	/// to recover task progress, but a temporary network failure does not hide the locally known state.
	public func getOfflineResourceState(for resource: OfflineResource) async throws -> OfflineResourceState {
		try ensureActive()
		await taskRunner.synchronizeState()
		if let state = try await resourceStateTracker.state(for: OfflineResourceKey(resource)) {
			return state
		}
		return try await localResourceState(for: resource)
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
		guard isActive else {
			return AsyncStream { $0.finish() }
		}
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

				while !Task.isCancelled, isActive {
					try? await Task.sleep(nanoseconds: collectionDownloadStatePollInterval)
					guard !Task.isCancelled, isActive else {
						break
					}

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
		case let .title(direction):
			(page, failures) = try await offlineStore.getCollectionItemsOrderByTitle(
				collectionType: collectionType,
				resourceId: resourceId,
				direction: direction,
				limit: limit,
				after: cursor
			)
		case let .album(direction):
			(page, failures) = try await offlineStore.getCollectionItemsOrderByAlbum(
				collectionType: collectionType,
				resourceId: resourceId,
				direction: direction,
				limit: limit,
				after: cursor
			)
		case let .artist(direction):
			(page, failures) = try await offlineStore.getCollectionItemsOrderByArtist(
				collectionType: collectionType,
				resourceId: resourceId,
				direction: direction,
				limit: limit,
				after: cursor
			)
		case let .dateAdded(direction):
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
		guard !failures.isEmpty else {
			return
		}
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
		try await perform(
			action: .store,
			resource: .media(type: mediaType, resourceId: resourceId.stringValue),
			resourceType: mediaType.toResourceType
		)
	}

	public func download(collectionType: OfflineCollectionType, resourceId: ResourceId) async throws {
		try await perform(
			action: .store,
			resource: .collection(type: collectionType, resourceId: resourceId.stringValue),
			resourceType: collectionType.toResourceType
		)
	}

	public func remove(mediaType: OfflineMediaItemType, resourceId: ResourceId) async throws {
		try await perform(
			action: .remove,
			resource: .media(type: mediaType, resourceId: resourceId.stringValue),
			resourceType: mediaType.toResourceType
		)
	}

	public func remove(collectionType: OfflineCollectionType, resourceId: ResourceId) async throws {
		try await perform(
			action: .remove,
			resource: .collection(type: collectionType, resourceId: resourceId.stringValue),
			resourceType: collectionType.toResourceType
		)
		// Optimistically update local availability; the remove task performs the same idempotent cleanup.
		try? offlineStore.deleteCollection(
			resourceType: collectionType.rawValue,
			resourceId: collectionLocalResourceId(collectionType: collectionType, resourceId: resourceId)
		)
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

	private func perform(
		action: InternalOfflineResourceAction,
		resource: OfflineResource,
		resourceType: ResourceType
	) async throws {
		try ensureActive()
		let key = OfflineResourceKey(resource)
		let localState = try await localResourceState(for: resource)
		if let knownState = try await resourceStateTracker.state(for: key) {
			if action == .store, localState == .downloaded,
			   knownState == .downloaded || knownState == .failed(action: .remove)
			{
				await resourceStateTracker.resolve(key, state: .downloaded)
				return
			}
			if action == .remove, localState == .notDownloaded,
			   knownState == .notDownloaded || knownState == .failed(action: .download)
			{
				await resourceStateTracker.resolve(key, state: .notDownloaded)
				return
			}
			guard try await resourceStateTracker.begin(action, for: key) else {
				return
			}
		} else {
			if action == .store, localState == .downloaded {
				return
			}
			guard try await resourceStateTracker.begin(action, for: key) else {
				return
			}
		}
		do {
			switch action {
			case .store:
				try await offlineApiClient.addItem(type: resourceType, id: key.resourceId)
			case .remove:
				try await offlineApiClient.removeItem(type: resourceType, id: key.resourceId)
			}
		} catch {
			await resourceStateTracker.registrationFailed(action, for: key)
			throw error
		}
		await taskRunner.run()
	}

	private func localResourceState(for resource: OfflineResource) async throws -> OfflineResourceState {
		switch resource {
		case let .media(mediaType, resourceId):
			try await offlineStore.getMediaItem(mediaType: mediaType, resourceId: resourceId) == nil
				? .notDownloaded
				: .downloaded
		case let .collection(collectionType, resourceId):
			try await offlineStore.getCollection(
				collectionType: collectionType,
				resourceId: collectionLocalResourceId(
					collectionType: collectionType,
					resourceId: .identifier(resourceId)
				)
			) == nil ? .notDownloaded : .downloaded
		}
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
		guard isActive else {
			throw OfflinerLifecycleError.reset
		}
	}
}

// MARK: - Internal Mappings

extension OfflineMediaItemType {
	var toResourceType: ResourceType {
		switch self {
		case .tracks: .track
		case .videos: .video
		}
	}
}

extension OfflineCollectionType {
	var toResourceType: ResourceType {
		switch self {
		case .albums: .album
		case .playlists: .playlist
		case .userCollectionTracks: .userCollectionTracks
		}
	}
}
