import Foundation
import GRDB

// MARK: - Offliner

public final class Offliner {
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let storage: OfflinerStorage
	private let taskRunner: TaskRunner
	private let mediaDownloader: MediaDownloaderProtocol
	private let resourceStateTracker: ResourceStateTracker
	private var trackManifestFetcher: TrackManifestFetcherProtocol
	private let lifecycleLock = NSLock()
	private let playbackReplacementLock = NSLock()
	private var isReset = false
	private var resetTask: Task<Void, Error>?
	private var playbackReplacementResources: Set<OfflineResourceKey> = []

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

	@discardableResult
	public func handleBackgroundURLSessionEvents(identifier: String, completionHandler: @escaping () -> Void) -> Bool {
		guard isActive else { return false }
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
			backgroundSessionIdentifier: storage.backgroundSessionIdentifier
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
		self.trackManifestFetcher = trackManifestFetcher
		self.audioFormats = configuration.audioFormats
		self.taskRunner = TaskRunner(
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
		videoManifestFetcher: VideoManifestFetcherProtocol
	) {
		let offlineStore = storage.offlineStore
		let licenseDownloader = licenseDownloader ?? LicenseDownloader(fileStorage: storage.fileStorage)
		let resourceStateTracker = ResourceStateTracker(offlineStore: offlineStore)
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.storage = storage
		self.mediaDownloader = mediaDownloader
		self.resourceStateTracker = resourceStateTracker
		self.trackManifestFetcher = trackManifestFetcher
		self.audioFormats = configuration.audioFormats
		self.taskRunner = TaskRunner(
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
			schedulePlaybackAssetReplacement(mediaType: mediaType, resourceId: resourceId)
			return nil
		}
	}

	/// Returns an AVFoundation asset prepared for unprotected or stored-license playback.
	///
	/// Retain the returned object for the entire lifetime of every `AVPlayerItem` made from its `urlAsset`, including while
	/// queued. If stored playback files or license preparation cannot be resolved, this returns `nil` and schedules one
	/// idempotent replacement download.
	public func getOfflinePlaybackAVAsset(
		mediaType: OfflineMediaItemType,
		resourceId: ResourceId
	) async -> OfflinePlaybackAVAsset? {
		guard let playbackAsset = await getOfflinePlaybackAsset(mediaType: mediaType, resourceId: resourceId) else {
			return nil
		}
		do {
			return try OfflinePlaybackAVAsset(playbackAsset: playbackAsset)
		} catch {
			schedulePlaybackAssetReplacement(mediaType: mediaType, resourceId: resourceId)
			return nil
		}
	}

	private func schedulePlaybackAssetReplacement(mediaType: OfflineMediaItemType, resourceId: ResourceId) {
		let resource = OfflineResourceKey(resourceType: mediaType.rawValue, resourceId: resourceId.stringValue)
		playbackReplacementLock.lock()
		let inserted = playbackReplacementResources.insert(resource).inserted
		playbackReplacementLock.unlock()
		guard inserted else { return }

		Task {
			defer { finishPlaybackAssetReplacement(resource) }
			do {
				try offlineStore.invalidateMediaItem(resourceType: mediaType.rawValue, resourceId: resourceId.stringValue)
				try await download(mediaType: mediaType, resourceId: resourceId)
			} catch {
				// Playback lookup remains nonthrowing. Resource state exposes a failed replacement registration.
			}
		}
	}

	private func finishPlaybackAssetReplacement(_ resource: OfflineResourceKey) {
		playbackReplacementLock.lock()
		playbackReplacementResources.remove(resource)
		playbackReplacementLock.unlock()
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

	/// Observes distinct state changes for one media item or collection until reset or cancellation.
	public func observeOfflineResourceState(for resource: OfflineResource) -> AsyncStream<OfflineResourceState> {
		guard isActive else { return AsyncStream { $0.finish() } }
		let key = OfflineResourceKey(resource)
		return AsyncStream { continuation in
			let task = Task {
				do {
					var lastState = try await getOfflineResourceState(for: resource)
					continuation.yield(lastState)
					for await state in await resourceStateTracker.observe(key) where state != lastState {
						continuation.yield(state)
						lastState = state
					}
				} catch {
					// Observation is nonthrowing for source compatibility; registration and snapshot calls preserve errors.
				}
				continuation.finish()
			}
			continuation.onTermination = { _ in task.cancel() }
		}
	}

	/// Returns the active aggregate download queue after backend task synchronization completes.
	///
	/// Collection metadata and member tasks count as one collection entry. Direct media downloads remain separate entries.
	/// Successful operations disappear; failed downloads remain until explicitly retried, removed, or reset.
	public func getOfflineDownloadQueue() async throws -> [OfflineDownloadQueueEntry] {
		try ensureActive()
		try await taskRunner.synchronizeDownloadQueue()
		return try await resourceStateTracker.downloadQueueSnapshot()
	}

	/// Observes distinct aggregate download queue snapshots until cancellation or reset.
	///
	/// Every subscriber receives its own synchronized initial snapshot and all subsequent broadcasts. An initial backend or
	/// local persistence failure terminates only that subscriber with the original error.
	public func observeOfflineDownloadQueue() -> AsyncThrowingStream<[OfflineDownloadQueueEntry], Error> {
		guard isActive else {
			return AsyncThrowingStream { $0.finish(throwing: OfflinerLifecycleError.reset) }
		}
		return AsyncThrowingStream { continuation in
			let task = Task {
				do {
					try await taskRunner.synchronizeDownloadQueue()
					for await snapshot in try await resourceStateTracker.observeDownloadQueue() {
						try Task.checkCancellation()
						continuation.yield(snapshot)
					}
					continuation.finish()
				} catch {
					continuation.finish(throwing: error)
				}
			}
			continuation.onTermination = { _ in task.cancel() }
		}
	}

	/// Streams collection-level offline availability.
	///
	/// This compatibility stream maps the resource-scoped operation state into the original three availability states.
	/// Removal and failed downloads map to `.notDownloaded`; a failed removal preserves the collection's local availability.
	public func getOfflineCollectionDownloadState(
		collectionType: OfflineCollectionType,
		resourceId: ResourceId
	) -> AsyncStream<OfflineCollectionDownloadState> {
		let resource = OfflineResource.collection(type: collectionType, resourceId: resourceId.stringValue)
		return AsyncStream { continuation in
			let task = Task {
				for await state in observeOfflineResourceState(for: resource) {
					let legacyState: OfflineCollectionDownloadState = switch state {
					case .queued, .downloading: .downloading
					case .downloaded: .downloaded
					case .notDownloaded, .removing, .failed(action: .download): .notDownloaded
					case .failed(action: .remove):
						(try? await localResourceState(for: resource)) == .downloaded ? .downloaded : .notDownloaded
					}
					continuation.yield(legacyState)
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
			   knownState == .downloaded || knownState == .failed(action: .remove) {
				await resourceStateTracker.resolve(key, state: .downloaded)
				return
			}
			if action == .remove, localState == .notDownloaded,
			   knownState == .notDownloaded || knownState == .failed(action: .download) {
				await resourceStateTracker.resolve(key, state: .notDownloaded)
				return
			}
			guard try await resourceStateTracker.begin(action, for: key) else { return }
		} else {
			if action == .store, localState == .downloaded { return }
			guard try await resourceStateTracker.begin(action, for: key) else { return }
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
		case .media(let mediaType, let resourceId):
			return try await offlineStore.getMediaItem(mediaType: mediaType, resourceId: resourceId) == nil
				? .notDownloaded
				: .downloaded
		case .collection(let collectionType, let resourceId):
			return try await offlineStore.getCollection(
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
