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
	private var runningTasks: [InternalTask] = []
	private var taskIds: Set<String> = []

	private var isRunning = false
	private var needsRun = false
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

			while runningTasks.count < Self.maxConcurrentTasks, !pendingTasks.isEmpty {
				let task = pendingTasks.removeFirst()
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

	private func start(_ task: InternalTask) {
		let canUseExpensiveNetworks = allowDownloadsOnExpensiveNetworks
		let currentNetwork = network

		runningTasks.append(task)

		Task { [weak self] in
			guard currentNetwork.isInexpensive || canUseExpensiveNetworks else { return }

			await task.download?.updateState(.inProgress)
			try? await self?.offlineApiClient.updateTask(taskId: task.id, state: .inProgress)

			do {
				try await task.run()
				await task.download?.updateState(.completed)
				try? await self?.offlineApiClient.updateTask(taskId: task.id, state: .completed)
			} catch {
				print("Task \(task.id) failed: \(error)")
				await task.download?.updateState(.failed)
				try? await self?.offlineApiClient.updateTask(taskId: task.id, state: .failed)
			}

			await self?.finalize(task)
		}
	}

	private func finalize(_ task: InternalTask) async {
		runningTasks.removeAll { $0.id == task.id }
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
	func run() async throws
}

extension InternalTask {
	var download: Download? { nil }
}
