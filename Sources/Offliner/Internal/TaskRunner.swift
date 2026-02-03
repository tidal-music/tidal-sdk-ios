import Auth
import Foundation

actor TaskRunner {
	private static let maxConcurrentTasks = 5

	private let backendRepository: BackendRepositoryProtocol
	private let scheduler: Scheduler

	private let storeItemHandler: StoreItemHandler
	private let storeCollectionHandler: StoreCollectionHandler
	private let removeItemHandler: RemoveItemHandler
	private let removeCollectionHandler: RemoveCollectionHandler

	private var pendingTasks: [InternalTask] = []
	private var inProgressTasks: [InternalTask] = []
	private var taskIds: Set<String> = []
	private var taskCursor: String?

	private var downloadsList: [Download] = []
	private var downloadsContinuation: AsyncStream<Download>.Continuation?

	nonisolated let newDownloads: AsyncStream<Download>

	var currentDownloads: [Download] {
		downloadsList
	}

	init(
		backendRepository: BackendRepositoryProtocol,
		localRepository: LocalRepository,
		artworkDownloader: ArtworkRepositoryProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.backendRepository = backendRepository
		self.scheduler = Scheduler()

		var storedContinuation: AsyncStream<Download>.Continuation?
		self.newDownloads = AsyncStream { continuation in
			storedContinuation = continuation
		}
		self.downloadsContinuation = storedContinuation

		self.storeItemHandler = StoreItemHandler(
			backendRepository: backendRepository,
			localRepository: localRepository,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader
		)
		self.storeCollectionHandler = StoreCollectionHandler(
			backendRepository: backendRepository,
			localRepository: localRepository,
			artworkDownloader: artworkDownloader
		)
		self.removeItemHandler = RemoveItemHandler(
			backendRepository: backendRepository,
			localRepository: localRepository
		)
		self.removeCollectionHandler = RemoveCollectionHandler(
			backendRepository: backendRepository,
			localRepository: localRepository
		)
	}

	func run() async throws {
		try await scheduler.trigger {
			try await self.start()
		}
	}

	private func start() async throws {
		try await fetchTasks()

		let capacity = max(0, Self.maxConcurrentTasks - inProgressTasks.count)
		let tasksToStart = Array(pendingTasks.prefix(capacity))

		for task in tasksToStart {
			pendingTasks.removeAll { $0.id == task.id }
			inProgressTasks.append(task)

			switch task.offlineTask {
			case .storeItem:
				Task { [weak self] in
					guard let download = task.download else {
						try? await self?.finalize(task)
						return
					}

					await self?.storeItemHandler.start(download) { [weak self] in
						try? await self?.finalize(task)
					}
				}
			case let .storeCollection(storeCollectionTask):
				Task { [weak self] in
					await self?.storeCollectionHandler.execute(storeCollectionTask)
					try? await self?.finalize(task)
				}
			case let .removeItem(removeItemTask):
				Task { [weak self] in
					await self?.removeItemHandler.execute(removeItemTask)
					try? await self?.finalize(task)
				}
			case let .removeCollection(removeCollectionTask):
				Task { [weak self] in
					await self?.removeCollectionHandler.execute(removeCollectionTask)
					try? await self?.finalize(task)
				}
			}
		}
	}

	private func finalize(_ task: InternalTask) async throws {
		inProgressTasks.removeAll { $0.id == task.id }
		taskIds.remove(task.id)
		if let download = task.download {
			downloadsList.removeAll { $0 === download }
		}

		try await run()
	}

	private func fetchTasks() async throws {
		guard pendingTasks.count <= Self.maxConcurrentTasks else {
			return
		}

		let (tasks, cursor) = try await backendRepository.getTasks(cursor: taskCursor)
		for task in tasks.map(InternalTask.init) where taskIds.insert(task.id).inserted {
			pendingTasks.append(task)
			if case let .storeItem(storeItemTask) = task.offlineTask {
				let download = Download(task: storeItemTask, state: .pending)
				task.download = download
				downloadsList.append(download)
				downloadsContinuation?.yield(download)
			}
		}

		if let c = cursor {
			taskCursor = c
		}
	}
}

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

private actor Scheduler {
	private var task: Task<Void, Error>?
	private var rerun = false

	func trigger(_ work: @Sendable @escaping () async throws -> Void) async throws {
		if let t = task {
			rerun = true
			try await t.value
			return
		}

		let t = Task<Void, Error> { [weak self] in
			guard let self else { return }

			do {
				repeat {
					try await work()
				} while !(await self.stop())

				await self.finish()
			} catch {
				await self.finish()
				throw error
			}
		}

		task = t
		try await t.value
	}

	private func stop() -> Bool {
		let shouldContinue = rerun
		rerun = false
		return !shouldContinue
	}

	private func finish() {
		task = nil
		rerun = false
	}
}
