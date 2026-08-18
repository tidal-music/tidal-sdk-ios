import Foundation
import Network
import OSLog

// MARK: - TaskRunner

actor TaskRunner {
	private enum CollectionDownloadRequestState {
		case requested
		case acknowledged
	}

	private static let logger = Logger(subsystem: "com.tidal.sdk.offliner", category: "TaskRunner")
	private static let maxConcurrentTasks = 5
	private static let refreshThreshold = 10

	private let storeTrackHandler: StoreTrackHandler
	private let storeVideoHandler: StoreVideoHandler
	private let storeAlbumHandler: StoreAlbumHandler
	private let storePlaylistHandler: StorePlaylistHandler
	private let storeUserCollectionTracksHandler: StoreUserCollectionTracksHandler
	private let removeItemHandler: RemoveItemHandler
	private let removeCollectionHandler: RemoveCollectionHandler

	private let offlineApiClient: OfflineApiClientProtocol
	private let network: Network

	private var pendingTasks: [InternalTask] = []
	private var runningTasks: [InternalTask] = []
	private var taskIds: Set<String> = []
	private var collectionDownloadRequests: [OfflineCollectionReference: CollectionDownloadRequestState] = [:]

	private var processTask: Task<Void, Never>?
	private var rerunRequested = false

	private(set) var currentDownloads: [Download] = []
	private var downloadsContinuation: AsyncStream<Download>.Continuation?

	nonisolated let newDownloads: AsyncStream<Download>

	var allowDownloadsOnExpensiveNetworks: Bool

	init(
		configuration: Configuration,
		offlineApiClient: OfflineApiClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		licenseDownloader: LicenseDownloader,
		trackManifestFetcher: TrackManifestFetcherProtocol,
		videoManifestFetcher: VideoManifestFetcherProtocol
	) {
		self.offlineApiClient = offlineApiClient
		allowDownloadsOnExpensiveNetworks = configuration.allowDownloadsOnExpensiveNetworks
		network = Network()

		let (stream, continuation) = AsyncStream<Download>.makeStream()
		newDownloads = stream
		downloadsContinuation = continuation

		storeTrackHandler = StoreTrackHandler(
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			manifestFetcher: trackManifestFetcher,
			licenseDownloader: licenseDownloader
		)
		storeVideoHandler = StoreVideoHandler(
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			manifestFetcher: videoManifestFetcher,
			licenseDownloader: licenseDownloader
		)
		storeAlbumHandler = StoreAlbumHandler(
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader
		)
		storePlaylistHandler = StorePlaylistHandler(
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader
		)
		storeUserCollectionTracksHandler = StoreUserCollectionTracksHandler(
			offlineStore: offlineStore
		)
		removeItemHandler = RemoveItemHandler(
			offlineStore: offlineStore
		)
		removeCollectionHandler = RemoveCollectionHandler(
			offlineStore: offlineStore
		)
	}

	func run() {
		guard processTask == nil else {
			rerunRequested = true
			return
		}

		processTask = Task {
			repeat {
				rerunRequested = false
				await process()
			} while rerunRequested
			processTask = nil
		}
	}

	func setAllowDownloadsOnExpensiveNetworks(_ allowed: Bool) {
		allowDownloadsOnExpensiveNetworks = allowed
		if allowed {
			run()
		}
	}

	func hasCurrentDownload(relatedTo collectionType: OfflineCollectionType, resourceId: ResourceId) -> Bool {
		let collection = OfflineCollectionReference(collectionType: collectionType, resourceId: resourceId)
		return hasCurrentDownload(for: collection)
	}

	func beginCollectionDownload(collectionType: OfflineCollectionType, resourceId: ResourceId) {
		let collection = OfflineCollectionReference(collectionType: collectionType, resourceId: resourceId)
		if collectionDownloadRequests[collection] == nil {
			collectionDownloadRequests[collection] = hasCurrentDownload(for: collection) ? .acknowledged : .requested
		}
	}

	func cancelCollectionDownloadRequest(collectionType: OfflineCollectionType, resourceId: ResourceId) {
		collectionDownloadRequests.removeValue(
			forKey: OfflineCollectionReference(collectionType: collectionType, resourceId: resourceId)
		)
	}

	func isCollectionDownloadRequestActive(relatedTo collectionType: OfflineCollectionType, resourceId: ResourceId) -> Bool {
		let collection = OfflineCollectionReference(collectionType: collectionType, resourceId: resourceId)
		guard let requestState = collectionDownloadRequests[collection] else {
			return false
		}

		let hasCurrentDownload = hasCurrentDownload(for: collection)
		switch requestState {
		case .requested:
			if hasCurrentDownload {
				collectionDownloadRequests[collection] = .acknowledged
			}
			return true
		case .acknowledged where hasCurrentDownload:
			return true
		case .acknowledged:
			collectionDownloadRequests[collection] = nil
			return false
		}
	}

	private func hasCurrentDownload(for collection: OfflineCollectionReference) -> Bool {
		pendingTasks.contains { $0.isDownloadTask(for: collection) } ||
			runningTasks.contains { $0.isDownloadTask(for: collection) }
	}

	private func refresh() async throws {
		let (tasks, _) = try await offlineApiClient.getTasks(cursor: nil)

		for task in tasks where taskIds.insert(task.id).inserted {
			let pendingTask = handle(task)
			let matchingRequests = collectionDownloadRequests.keys.filter { pendingTask.isDownloadTask(for: $0) }
			for collection in matchingRequests {
				collectionDownloadRequests[collection] = .acknowledged
			}
			pendingTasks.append(pendingTask)
			if let download = pendingTask.download {
				currentDownloads.append(download)
				downloadsContinuation?.yield(download)
			}
		}
	}

	private func handle(_ offlineTask: OfflineTask) -> InternalTask {
		switch offlineTask {
		case let .storeTrack(task): storeTrackHandler.handle(task)
		case let .storeVideo(task): storeVideoHandler.handle(task)
		case let .storeAlbum(task): storeAlbumHandler.handle(task)
		case let .storePlaylist(task): storePlaylistHandler.handle(task)
		case let .storeUserCollectionTracks(task): storeUserCollectionTracksHandler.handle(task)
		case let .removeItem(task): removeItemHandler.handle(task)
		case let .removeCollection(task): removeCollectionHandler.handle(task)
		}
	}

	private func process() async {
		if pendingTasks.count < Self.refreshThreshold {
			try? await refresh()
		}

		await withTaskGroup(of: Void.self) { group in
			for _ in 0 ..< Self.maxConcurrentTasks {
				if let task = getTask() {
					group.addTask { await self.start(task) }
				}
			}

			for await _ in group {
				if pendingTasks.count < Self.refreshThreshold {
					try? await refresh()
				}

				if let task = getTask() {
					group.addTask { await self.start(task) }
				}
			}
		}
	}

	private func getTask() -> InternalTask? {
		let runningKeys = Set(runningTasks.map(\.concurrencyKey))

		guard let index = pendingTasks.firstIndex(where: { !runningKeys.contains($0.concurrencyKey) }) else {
			return nil
		}

		let task = pendingTasks.remove(at: index)
		runningTasks.append(task)
		return task
	}

	private func start(_ task: InternalTask) async {
		while !allowDownloadsOnExpensiveNetworks, await !(network.isInexpensive) {
			try? await Task.sleep(nanoseconds: 1_000_000_000)
		}

		do {
			try await offlineApiClient.updateTask(taskId: task.id, state: .inProgress)
		} catch {
			Self.logger.error("Failed to mark task \(task.id, privacy: .public) as in progress, skipping it: \(error, privacy: .public)")
			await task.download?.updateState(.failed)
			finish(task)
			return
		}

		await task.download?.updateState(.inProgress)

		do {
			try await task.run()
			await task.download?.updateState(.completed)
			try? await offlineApiClient.updateTask(taskId: task.id, state: .completed)
		} catch {
			Self.logger.error("Task \(task.id, privacy: .public) failed: \(error, privacy: .public)")
			await task.download?.updateState(.failed)
			try? await offlineApiClient.updateTask(taskId: task.id, state: .failed)
		}

		finish(task)
	}

	private func finish(_ task: InternalTask) {
		runningTasks.removeAll { $0 === task }
		taskIds.remove(task.id)
		if let download = task.download {
			currentDownloads.removeAll { $0 === download }
		}
	}
}

// MARK: - Network

private actor Network {
	private let monitor = NWPathMonitor()
	private(set) var isInexpensive = true

	init() {
		monitor.pathUpdateHandler = { [weak self] path in
			guard path.status == .satisfied else {
				return
			}
			guard let self else {
				return
			}
			let inexpensive = !path.isExpensive && !path.isConstrained
			Task { await self.setInexpensive(inexpensive) }
		}
		monitor.start(queue: DispatchQueue(label: "taskrunner.network.monitor"))
	}

	private func setInexpensive(_ value: Bool) {
		isInexpensive = value
	}
}

// MARK: - OfflineTaskConcurrencyKey

struct OfflineTaskConcurrencyKey: Hashable, Sendable {
	let collectionType: String?
	let collectionId: String?
	let resourceType: String
	let resourceId: String

	init(collectionType: String? = nil, collectionId: String? = nil, resourceType: String, resourceId: String) {
		let userCollectionTracks = OfflineCollectionType.userCollectionTracks.rawValue
		self.collectionType = collectionType
		self.collectionId = collectionType == userCollectionTracks ? ResourceId.me.stringValue : collectionId
		self.resourceType = resourceType
		self.resourceId = resourceType == userCollectionTracks ? ResourceId.me.stringValue : resourceId
	}
}

// MARK: - InternalTask

protocol InternalTask: AnyObject {
	var id: String { get }
	var download: Download? { get }
	var concurrencyKey: OfflineTaskConcurrencyKey { get }
	func isDownloadTask(for collection: OfflineCollectionReference) -> Bool
	func run() async throws
}

extension InternalTask {
	var download: Download? { nil }

	func isDownloadTask(for collection: OfflineCollectionReference) -> Bool {
		download?.relatedCollection == collection
	}
}
