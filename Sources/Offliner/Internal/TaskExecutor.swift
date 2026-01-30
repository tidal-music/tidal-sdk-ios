import Auth
import Foundation

final class TaskExecutor {
	private let taskRunner: TaskRunner
	private var activeTasks: [String: Task<Void, Never>] = [:]

	private let storeItemHandler: StoreItemHandler
	private let storeCollectionHandler: StoreCollectionHandler
	private let removeItemHandler: RemoveItemHandler
	private let removeCollectionHandler: RemoveCollectionHandler

	init(taskRunner: TaskRunner, offlineRepository: OfflineRepository, credentialsProvider: CredentialsProvider) {
		self.taskRunner = taskRunner
		self.storeItemHandler = StoreItemHandler(offlineRepository: offlineRepository, credentialsProvider: credentialsProvider)
		self.storeCollectionHandler = StoreCollectionHandler(offlineRepository: offlineRepository)
		self.removeItemHandler = RemoveItemHandler(offlineRepository: offlineRepository)
		self.removeCollectionHandler = RemoveCollectionHandler(offlineRepository: offlineRepository)
	}

	func start(
		_ task: DownloadTask,
		completion: @escaping @Sendable (DownloadTask) async throws -> Void,
		failure: @escaping @Sendable (DownloadTask) async throws -> Void
	) {
		let taskId = task.id

		switch task.type {
		case .storeItem:
			storeItemHandler.start(task, completion: completion, failure: failure)

		case .storeCollection:
			activeTasks[taskId] = Task { [weak self] in
				guard let self else { return }
				do {
					try await storeCollectionHandler.execute(task)
					try await completion(task)
				} catch {
					try? await failure(task)
				}
				removeTask(taskId)
			}

		case .removeItem:
			activeTasks[taskId] = Task { [weak self] in
				guard let self else { return }
				do {
					try await removeItemHandler.execute(task)
					try await completion(task)
				} catch {
					try? await failure(task)
				}
				removeTask(taskId)
			}

		case .removeCollection:
			activeTasks[taskId] = Task { [weak self] in
				guard let self else { return }
				do {
					try await removeCollectionHandler.execute(task)
					try await completion(task)
				} catch {
					try? await failure(task)
				}
				removeTask(taskId)
			}
		}
	}

	func cancel(_ task: DownloadTask) {
		switch task.type {
		case .storeItem:
			storeItemHandler.cancel(task)
		default:
			activeTasks[task.id]?.cancel()
			activeTasks.removeValue(forKey: task.id)
		}
	}

	func cancelAll() {
		for task in activeTasks.values {
			task.cancel()
		}
		activeTasks.removeAll()
		// TODO: Cancel all storeItemHandler tasks
	}

	private func removeTask(_ taskId: String) {
		activeTasks.removeValue(forKey: taskId)
	}
}
