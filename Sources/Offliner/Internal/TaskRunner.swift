import Auth
import Foundation

actor TaskRunner {
	private static let maxConcurrentTasks = 5
	private static let maxQueueSize = 80

	private let backendClient: BackendClientProtocol

	private let storeItemHandler: StoreItemHandler
	private let storeCollectionHandler: StoreCollectionHandler
	private let removeItemHandler: RemoveItemHandler
	private let removeCollectionHandler: RemoveCollectionHandler

	private var pendingTasks: [InternalTask] = []
	private var inProgressTasks: [InternalTask] = []
	private var taskIds: Set<String> = []
	private var taskCursor: String?

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
		if pendingTasks.count < Self.maxQueueSize {
			try await refresh()
		}

		while inProgressTasks.count < Self.maxConcurrentTasks, let task = pendingTasks.first {
			pendingTasks.removeFirst()
			inProgressTasks.append(task)
			start(task)
		}
	}

	private func refresh() async throws {
		let (tasks, cursor) = try await backendClient.getTasks(cursor: taskCursor)

		for task in tasks.map(InternalTask.init) where taskIds.insert(task.id).inserted {
			pendingTasks.append(task)
			if case let .storeItem(storeItemTask) = task.offlineTask {
				let download = Download(task: storeItemTask)
				task.download = download
				currentDownloads.append(download)
				downloadsContinuation?.yield(download)
			}
		}

		if let newCursor = cursor {
			taskCursor = newCursor
		}
	}

	private func start(_ task: InternalTask) {
		switch task.offlineTask {
		case .storeItem:
			Task { [weak self] in
				guard let download = task.download else {
					await self?.finalize(task)
					return
				}

				await self?.storeItemHandler.start(download) { [weak self] in
					await self?.finalize(task)
				}
			}
		case let .storeCollection(storeCollectionTask):
			Task { [weak self] in
				await self?.storeCollectionHandler.execute(storeCollectionTask)
				await self?.finalize(task)
			}
		case let .removeItem(removeItemTask):
			Task { [weak self] in
				await self?.removeItemHandler.execute(removeItemTask)
				await self?.finalize(task)
			}
		case let .removeCollection(removeCollectionTask):
			Task { [weak self] in
				await self?.removeCollectionHandler.execute(removeCollectionTask)
				await self?.finalize(task)
			}
		}
	}

	private func finalize(_ task: InternalTask) async {
		inProgressTasks.removeAll { $0.id == task.id }
		taskIds.remove(task.id)
		if let download = task.download {
			currentDownloads.removeAll { $0 === download }
		}

		// Trigger another run to keep the queue moving
		try? await run()
	}
}

// MARK: - InternalTask

private class InternalTask: Equatable {
	let id: String
	let offlineTask: OfflineTask
	weak var download: Download?

	init(from task: OfflineTask) {
		self.id = task.id
		self.offlineTask = task
	}

	static func == (lhs: InternalTask, rhs: InternalTask) -> Bool {
		lhs.id == rhs.id
	}
}
