import Foundation

actor TaskRunner {
	private static let maxConcurrentTasks = 5
	private static let maxQueueSize = 80

	private let storeItemHandler: StoreItemHandler
	private let storeCollectionHandler: StoreCollectionHandler
	private let removeItemHandler: RemoveItemHandler
	private let removeCollectionHandler: RemoveCollectionHandler

	private let backendClient: BackendClientProtocol

	private var pendingTasks: [InternalTask] = []
	private var inProgressTasks: [InternalTask] = []
	private var taskIds: Set<String> = []

	private var isRunning = false
	private var needsRun = false

	private(set) var currentDownloads: [Download] = []
	private var downloadsContinuation: AsyncStream<Download>.Continuation?

	nonisolated let newDownloads: AsyncStream<Download>

	init(
		backendClient: BackendClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.backendClient = backendClient

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
		self.removeItemHandler = RemoveItemHandler(
			backendClient: backendClient,
			offlineStore: offlineStore
		)
		self.removeCollectionHandler = RemoveCollectionHandler(
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

	private func refresh() async throws {
		let (tasks, _) = try await backendClient.getTasks(cursor: nil)

		for task in tasks where taskIds.insert(task.id).inserted {
			if let internalTask = await handle(task) {
				pendingTasks.append(internalTask)
				if let download = internalTask.download {
					currentDownloads.append(download)
					downloadsContinuation?.yield(download)
				}
			}
		}
	}

	private func handle(_ offlineTask: OfflineTask) async -> InternalTask? {
		switch offlineTask {
		case .storeItem(let task): await storeItemHandler.handle(task)
		case .storeCollection(let task): await storeCollectionHandler.handle(task)
		case .removeItem(let task): await removeItemHandler.handle(task)
		case .removeCollection(let task): await removeCollectionHandler.handle(task)
		}
	}

	private func start(_ task: InternalTask) {
		Task { [weak self] in
			await task.run()
			await self?.finalize(task)
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

protocol InternalTask: AnyObject {
	var id: String { get }
	var download: Download? { get }
	func run() async
}

extension InternalTask {
	var download: Download? { nil }
}
