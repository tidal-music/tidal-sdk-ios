import Foundation
import Network
import OSLog

actor TaskRunner {
	private static let logger = Logger(subsystem: "com.tidal.sdk.offliner", category: "TaskRunner")
	private static let maxConcurrentTasks = 5
	private static let maxQueueSize = 80

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

	private var processTask: Task<Void, Never>?
	private var cursor: String?

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
		self.allowDownloadsOnExpensiveNetworks = configuration.allowDownloadsOnExpensiveNetworks
		self.network = Network()

		let (stream, continuation) = AsyncStream<Download>.makeStream()
		self.newDownloads = stream
		self.downloadsContinuation = continuation

		self.storeTrackHandler = StoreTrackHandler(
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			manifestFetcher: trackManifestFetcher,
			licenseDownloader: licenseDownloader
		)
		self.storeVideoHandler = StoreVideoHandler(
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			manifestFetcher: videoManifestFetcher,
			licenseDownloader: licenseDownloader
		)
		self.storeAlbumHandler = StoreAlbumHandler(
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader
		)
		self.storePlaylistHandler = StorePlaylistHandler(
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader
		)
		self.storeUserCollectionTracksHandler = StoreUserCollectionTracksHandler(
			offlineStore: offlineStore
		)
		self.removeItemHandler = RemoveItemHandler(
			offlineStore: offlineStore
		)
		self.removeCollectionHandler = RemoveCollectionHandler(
			offlineStore: offlineStore
		)
	}

	func run() {
		guard processTask == nil else { return }

		processTask = Task {
			await process()
			processTask = nil
		}
	}

	func setAllowDownloadsOnExpensiveNetworks(_ allowed: Bool) {
		allowDownloadsOnExpensiveNetworks = allowed
		if allowed {
			run()
		}
	}

	private func refresh() async throws {
		let (tasks, cursor) = try await offlineApiClient.getTasks(cursor: self.cursor)

		for task in tasks where taskIds.insert(task.id).inserted {
			let pendingTask = handle(task)
			pendingTasks.append(pendingTask)
			if let download = pendingTask.download {
				currentDownloads.append(download)
				downloadsContinuation?.yield(download)
			}
		}

		if let cursor {
			self.cursor = cursor
		}
	}

	private func handle(_ offlineTask: OfflineTask) -> InternalTask {
		switch offlineTask {
		case .storeTrack(let task): storeTrackHandler.handle(task)
		case .storeVideo(let task): storeVideoHandler.handle(task)
		case .storeAlbum(let task): storeAlbumHandler.handle(task)
		case .storePlaylist(let task): storePlaylistHandler.handle(task)
		case .storeUserCollectionTracks(let task): storeUserCollectionTracksHandler.handle(task)
		case .removeItem(let task): removeItemHandler.handle(task)
		case .removeCollection(let task): removeCollectionHandler.handle(task)
		}
	}

	private func process() async {
		if pendingTasks.count < Self.maxQueueSize {
			try? await refresh()
		}

		await withTaskGroup(of: Void.self) { group in
			for task in pendingTasks.prefix(Self.maxConcurrentTasks) {
				group.addTask { await self.start(task) }
			}

			for await _ in group {
				if let task = pendingTasks.first {
					group.addTask { await self.start(task) }
				}

				if pendingTasks.count < Self.maxQueueSize {
					try? await refresh()
				}
			}
		}
	}

	private func start(_ task: InternalTask) async {
		guard await network.isInexpensive || allowDownloadsOnExpensiveNetworks else { return }

		pendingTasks.removeAll { $0 === task }
		runningTasks.append(task)

		await task.download?.updateState(.inProgress)
		try? await offlineApiClient.updateTask(taskId: task.id, state: .inProgress)

		do {
			try await task.run()
			await task.download?.updateState(.completed)
			try? await offlineApiClient.updateTask(taskId: task.id, state: .completed)
		} catch {
			Self.logger.error("Task \(task.id, privacy: .public) failed: \(error, privacy: .public)")
			await task.download?.updateState(.failed)
			try? await offlineApiClient.updateTask(taskId: task.id, state: .failed)
		}

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
			guard path.status == .satisfied else { return }
			guard let self else { return }
			let inexpensive = !path.isExpensive && !path.isConstrained
			Task { await self.setInexpensive(inexpensive) }
		}
		monitor.start(queue: DispatchQueue(label: "taskrunner.network.monitor"))
	}

	private func setInexpensive(_ value: Bool) {
		isInexpensive = value
	}
}

// MARK: - InternalTask

protocol InternalTask: AnyObject {
	var id: String { get }
	var download: Download? { get }
	func run() async throws
}

extension InternalTask {
	var download: Download? { nil }
}
