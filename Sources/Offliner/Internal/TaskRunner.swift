import Auth
import Foundation

actor TaskRunner {
	private static let maxConcurrentTasks = 5

	private let backendRepository: BackendRepository
	private let scheduler: Scheduler

	private let storeItemHandler: StoreItemHandler
	private let storeCollectionHandler: StoreCollectionHandler
	private let removeItemHandler: RemoveItemHandler
	private let removeCollectionHandler: RemoveCollectionHandler

	private var activeTasks: [String: Task<Void, Never>] = [:]
	private var tasks: [DownloadTask] = []
	private var taskIds: Set<String> = []
	private var taskCursor: String?

	private(set) var mediaDownloads: [MediaDownload] = []

	init(backendRepository: BackendRepository, offlineRepository: OfflineRepository, credentialsProvider: CredentialsProvider) {
		self.backendRepository = backendRepository
		self.scheduler = Scheduler()
		self.storeItemHandler = StoreItemHandler(offlineRepository: offlineRepository, credentialsProvider: credentialsProvider)
		self.storeCollectionHandler = StoreCollectionHandler(offlineRepository: offlineRepository)
		self.removeItemHandler = RemoveItemHandler(offlineRepository: offlineRepository)
		self.removeCollectionHandler = RemoveCollectionHandler(offlineRepository: offlineRepository)
	}

	func run() async throws {
		try await scheduler.trigger {
			try await self.start()
		}
	}

	func completed(_ task: DownloadTask) async throws {
		try await backendRepository.updateTask(taskId: task.id, state: .completed)
		try await finalize(task)
	}

	func failed(_ task: DownloadTask) async throws {
		try await backendRepository.updateTask(taskId: task.id, state: .failed)
		try await finalize(task)
	}

	private func start() async throws {
		try await addTasks()

		let tasksInProgress = tasks.filter { $0.state == .inProgress }
		let capacity = max(0, Self.maxConcurrentTasks - tasksInProgress.count)
		let tasksToStart = Array(tasks.filter { $0.state == .pending }.prefix(capacity))

		tasksToStart.forEach { $0.updateState(.inProgress) }

		for task in tasksToStart {
			try await backendRepository.updateTask(taskId: task.id, state: .inProgress)
			switch task.offlineTask {
			case .storeItem:
				guard let mediaDownload = task.mediaDownload else { continue }
				storeItem(task, mediaDownload: mediaDownload)
			case let .storeCollection(storeCollectionTask):
				storeCollection(task, storeCollectionTask: storeCollectionTask)
			case let .removeItem(removeItemTask):
				removeItem(task, removeItemTask: removeItemTask)
			case let .removeCollection(removeCollectionTask):
				removeCollection(task, removeCollectionTask: removeCollectionTask)
			}
		}
	}

	private func finalize(_ task: DownloadTask) async throws {
		tasks.removeAll { $0.id == task.id }
		taskIds.remove(task.id)
		activeTasks.removeValue(forKey: task.id)
		if let mediaDownload = task.mediaDownload {
			mediaDownloads.removeAll { $0 === mediaDownload }
		}

		try await run()
	}

	private func storeItem(_ task: DownloadTask, mediaDownload: MediaDownload) {
		storeItemHandler.start(
			mediaDownload,
			onComplete: { [weak self, weak task] in
				guard let task else { return }
				try? await self?.completed(task)
			},
			onFailure: { [weak self, weak task] in
				guard let task else { return }
				try? await self?.failed(task)
			}
		)
	}

	private func storeCollection(_ task: DownloadTask, storeCollectionTask: StoreCollectionTask) {
		activeTasks[task.id] = Task { [weak self] in
			guard let self else { return }
			do {
				try await storeCollectionHandler.execute(storeCollectionTask)
				try await completed(task)
			} catch {
				try? await failed(task)
			}
		}
	}

	private func removeItem(_ task: DownloadTask, removeItemTask: RemoveItemTask) {
		activeTasks[task.id] = Task { [weak self] in
			guard let self else { return }
			do {
				try await removeItemHandler.execute(removeItemTask)
				try await completed(task)
			} catch {
				try? await failed(task)
			}
		}
	}

	private func removeCollection(_ task: DownloadTask, removeCollectionTask: RemoveCollectionTask) {
		activeTasks[task.id] = Task { [weak self] in
			guard let self else { return }
			do {
				try await removeCollectionHandler.execute(removeCollectionTask)
				try await completed(task)
			} catch {
				try? await failed(task)
			}
		}
	}

	private func addTasks() async throws {
		let pendingTasks = tasks.filter { $0.state == .pending }.count
		guard pendingTasks <= Self.maxConcurrentTasks else {
			return
		}

		let (tasks, cursor) = try await backendRepository.getTasks(cursor: taskCursor)
		for task in tasks.map(DownloadTask.init) where taskIds.insert(task.id).inserted {
			self.tasks.append(task)
			if case let .storeItem(storeItemTask) = task.offlineTask {
				let mediaDownload = MediaDownload(task: storeItemTask, state: task.state)
				task.mediaDownload = mediaDownload
				self.mediaDownloads.append(mediaDownload)
			}
		}

		if let c = cursor {
			taskCursor = c
		}
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
