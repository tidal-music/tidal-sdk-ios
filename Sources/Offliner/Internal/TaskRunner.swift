import Foundation
import Network

actor TaskRunner {
	private static let maxConcurrentTasks = 5
	private static let maxQueueSize = 80

	private let storeItemHandler: StoreItemHandler
	private let storeCollectionHandler: StoreCollectionHandler
	private let removeHandler: RemoveHandler

	private let backendClient: BackendClientProtocol
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
		backendClient: BackendClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.backendClient = backendClient
		self.allowDownloadsOnExpensiveNetworks = configuration.allowDownloadsOnExpensiveNetworks
		self.network = Network()

		let (stream, continuation) = AsyncStream<Download>.makeStream()
		self.newDownloads = stream
		self.downloadsContinuation = continuation

		self.storeItemHandler = StoreItemHandler(
			backendClient: backendClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader
		)
		self.storeCollectionHandler = StoreCollectionHandler(
			backendClient: backendClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader
		)
		self.removeHandler = RemoveHandler(
			backendClient: backendClient,
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
		let (tasks, _) = try await backendClient.getTasks(cursor: nil)

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
		case .storeItem(let task): storeItemHandler.handle(task)
		case .storeCollection(let task): storeCollectionHandler.handle(task)
		case .remove(let task): removeHandler.handle(task)
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
