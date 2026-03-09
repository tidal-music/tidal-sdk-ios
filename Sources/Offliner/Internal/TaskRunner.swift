import Foundation
import Network

actor TaskRunner {
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
	private var inProgressTasks: [InternalTask] = []
	private var taskIds: Set<String> = []

	private var isRunning = false
	private var needsRun = false

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
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			manifestFetcher: trackManifestFetcher
		)
		self.storeVideoHandler = StoreVideoHandler(
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			manifestFetcher: videoManifestFetcher
		)
		self.storeAlbumHandler = StoreAlbumHandler(
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader
		)
		self.storePlaylistHandler = StorePlaylistHandler(
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader
		)
		self.storeUserCollectionTracksHandler = StoreUserCollectionTracksHandler(
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore
		)
		self.removeItemHandler = RemoveItemHandler(
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore
		)
		self.removeCollectionHandler = RemoveCollectionHandler(
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore
		)
	}

	func run() async throws {
		if isRunning {
			needsRun = true
			return
		}

		isRunning = true
		defer { isRunning = false }

		repeat {
			needsRun = false

			if pendingTasks.count < Self.maxQueueSize {
				try await refresh()
			}

			while inProgressTasks.count < Self.maxConcurrentTasks, !pendingTasks.isEmpty {
				let task = pendingTasks.removeFirst()
				inProgressTasks.append(task)
				start(task)
			}
		} while needsRun
	}

	func setAllowDownloadsOnExpensiveNetworks(_ allowed: Bool) async {
		allowDownloadsOnExpensiveNetworks = allowed
		if allowed {
			try? await run()
		}
	}

	private func refresh() async throws {
		let (tasks, _) = try await offlineApiClient.getTasks(cursor: nil)

		for task in tasks where taskIds.insert(task.id).inserted {
			let internalTask = handle(task)
			pendingTasks.append(internalTask)
			if let download = internalTask.download {
				currentDownloads.append(download)
				downloadsContinuation?.yield(download)
			}
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

	private func start(_ task: InternalTask) {
		let allowDownloadsOnExpensiveNetworks = allowDownloadsOnExpensiveNetworks
		let network = network
		Task { [weak self] in
			if network.isInexpensive || allowDownloadsOnExpensiveNetworks {
				await task.run()
				await self?.finalize(task)
			}
		}
	}

	private func finalize(_ task: InternalTask) async {
		inProgressTasks.removeAll { $0 === task }
		taskIds.remove(task.id)
		if let download = task.download {
			currentDownloads.removeAll { $0 === download }
		}

		try? await run()
	}
}

// MARK: - Network

private final class Network {
	private let monitor = NWPathMonitor()
	private(set) var isInexpensive = true

	init() {
		monitor.pathUpdateHandler = { [weak self] path in
			guard path.status == .satisfied else { return }
			self?.isInexpensive = !path.isExpensive && !path.isConstrained
		}
		monitor.start(queue: DispatchQueue(label: "taskrunner.network.monitor"))
	}
}

// MARK: - InternalTask

protocol InternalTask: AnyObject {
	var id: String { get }
	var download: Download? { get }
	func run() async
}

extension InternalTask {
	var download: Download? { nil }
}
