import Foundation

actor TaskRunner {
	private static let maxConcurrentTasks = 5

	private let backendRepository: BackendRepository
	private let scheduler: Scheduler
	private var taskExecutor: TaskExecutor?

	private(set) var tasks: [DownloadTask] = []
	private var taskIds: Set<String> = []
	private var taskCursor: String?

	init(backendRepository: BackendRepository) {
		self.backendRepository = backendRepository
		self.scheduler = Scheduler()
	}

	func setExecutor(_ executor: TaskExecutor) {
		self.taskExecutor = executor
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
			taskExecutor?.start(
				task,
				completion: { [weak self] downloadTask in
					try await self?.completed(downloadTask)
				},
				failure: { [weak self] downloadTask in
					try await self?.failed(downloadTask)
				}
			)
		}
	}

	private func finalize(_ task: DownloadTask) async throws {
		tasks.removeAll { $0.id == task.id }
		taskIds.remove(task.id)

		try await run()
	}

	private func addTasks() async throws {
		let pendingTasks = tasks.filter { $0.state == .pending }.count
		guard pendingTasks <= Self.maxConcurrentTasks else {
			return
		}

		let (tasks, cursor) = try await backendRepository.getTasks(cursor: taskCursor)
		for task in tasks.map(DownloadTask.init) where taskIds.insert(task.id).inserted {
			self.tasks.append(task)
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
