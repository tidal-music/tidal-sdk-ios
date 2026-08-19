import Foundation
import Network
import OSLog

// MARK: - TaskRunner

actor TaskRunner {
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
	private let mediaDownloader: MediaDownloaderProtocol
	private let licenseDownloader: LicenseDownloader

	private var pendingTasks: [InternalTask] = []
	private var runningTasks: [InternalTask] = []
	private var taskIds: Set<String> = []

	private var processTask: Task<Void, Never>?
	private var rerunRequested = false
	private var isShutdown = false

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
		self.mediaDownloader = mediaDownloader
		self.licenseDownloader = licenseDownloader

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
		guard !isShutdown else {
			return
		}
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
		guard !isShutdown else {
			return
		}
		allowDownloadsOnExpensiveNetworks = allowed
		if allowed {
			run()
		}
	}

	func hasCurrentDownload(relatedTo collectionType: OfflineCollectionType, resourceId: ResourceId) -> Bool {
		guard !isShutdown else {
			return false
		}
		let collection = OfflineCollectionReference(collectionType: collectionType, resourceId: resourceId)
		return pendingTasks.contains { $0.isDownloadTask(for: collection) } ||
			runningTasks.contains { $0.isDownloadTask(for: collection) }
	}

	func shutdown() async {
		guard !isShutdown else {
			if let processTask {
				await processTask.value
			}
			return
		}

		isShutdown = true
		rerunRequested = false
		let task = processTask
		task?.cancel()
		await mediaDownloader.cancelAll()
		await licenseDownloader.cancelAll()
		await task?.value
		pendingTasks.removeAll()
		runningTasks.removeAll()
		taskIds.removeAll()
		currentDownloads.removeAll()
		downloadsContinuation?.finish()
		downloadsContinuation = nil
	}

	private func refresh() async throws {
		try Task.checkCancellation()
		guard !isShutdown else {
			return
		}
		let (tasks, _) = try await offlineApiClient.getTasks(cursor: nil)
		try Task.checkCancellation()
		guard !isShutdown else {
			return
		}

		for task in tasks where taskIds.insert(task.id).inserted {
			let pendingTask = handle(task)
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
		guard !isShutdown, !Task.isCancelled else {
			return
		}
		if pendingTasks.count < Self.refreshThreshold {
			try? await refresh()
		}

		await withTaskGroup(of: Void.self) { group in
			for _ in 0 ..< Self.maxConcurrentTasks where !Task.isCancelled && !isShutdown {
				if let task = getTask() {
					group.addTask { await self.start(task) }
				}
			}

			for await _ in group {
				guard !Task.isCancelled, !isShutdown else {
					group.cancelAll()
					continue
				}
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
		guard !isShutdown, !Task.isCancelled else {
			return nil
		}
		let runningKeys = Set(runningTasks.map(\.concurrencyKey))

		guard let index = pendingTasks.firstIndex(where: { !runningKeys.contains($0.concurrencyKey) }) else {
			return nil
		}

		let task = pendingTasks.remove(at: index)
		runningTasks.append(task)
		return task
	}

	private func start(_ task: InternalTask) async {
		guard !isShutdown, !Task.isCancelled else {
			finish(task)
			return
		}
		while !allowDownloadsOnExpensiveNetworks, await !(network.isInexpensive) {
			do {
				try await Task.sleep(nanoseconds: 1_000_000_000)
			} catch {
				finish(task)
				return
			}
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
			try Task.checkCancellation()
			guard !isShutdown else {
				throw CancellationError()
			}
			await task.download?.updateState(.completed)
			try? await offlineApiClient.updateTask(taskId: task.id, state: .completed)
		} catch is CancellationError {
			finish(task)
			return
		} catch {
			guard !isShutdown, !Task.isCancelled else {
				finish(task)
				return
			}
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
