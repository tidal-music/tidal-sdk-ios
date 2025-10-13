import Foundation

protocol RefreshCoalescing {
	func runOrJoinCredentials(
		key: String,
		requiresRefresh: Bool,
		operation: @Sendable @escaping () async throws -> AuthResult<Credentials>
	) async throws -> AuthResult<Credentials>

	func upgradeRefreshIntent(for key: String) async
}

actor RefreshCoordinator: RefreshCoalescing {
	private struct InFlightTask {
		let id: UUID
		let task: Task<AuthResult<Credentials>, Error>
		let requiresRefresh: Bool

		init(
			id: UUID = UUID(),
			task: Task<AuthResult<Credentials>, Error>,
			requiresRefresh: Bool
		) {
			self.id = id
			self.task = task
			self.requiresRefresh = requiresRefresh
		}
	}

	private var tasks: [String: InFlightTask] = [:]

	func runOrJoinCredentials(
		key: String,
		requiresRefresh: Bool,
		operation: @Sendable @escaping () async throws -> AuthResult<Credentials>
	) async throws -> AuthResult<Credentials> {
		// If a task is already in-flight for this key, join it instead of creating a new one
		if let existing = tasks[key] {
			if requiresRefresh && !existing.requiresRefresh {
				let currentPriority = Task.currentPriority
				let task = Task.detached(priority: currentPriority) {
					_ = try? await existing.task.value
					return try await operation()
				}
				let inFlightTask = InFlightTask(task: task, requiresRefresh: true)
				tasks[key] = inFlightTask

				Task.detached { [weak self, key, inFlightTask] in
					_ = try? await inFlightTask.task.value
					if let self {
						await self.clearTask(for: key, taskId: inFlightTask.id)
					}
				}

				return try await inFlightTask.task.value
			}

			return try await existing.task.value
		}

		// Create a new detached task to perform the operation.
		// Inherit the caller's priority to ensure high-priority requests (e.g., UI-driven)
		// don't get delayed by lower-priority background refresh operations.
		let currentPriority = Task.currentPriority
		let task = Task.detached(priority: currentPriority) {
			try await operation()
		}
		let inFlightTask = InFlightTask(task: task, requiresRefresh: requiresRefresh)
		tasks[key] = inFlightTask

		// Schedule cleanup of the task from the dictionary once it completes.
		// We capture the taskId at creation time to prevent a race condition:
		// if a new task with the same key is created before cleanup runs,
		// the taskId check in clearTask ensures we only remove our own task.
		Task.detached { [weak self, key, inFlightTask] in
			_ = try? await inFlightTask.task.value
			if let self {
				await self.clearTask(for: key, taskId: inFlightTask.id)
			}
		}

		return try await inFlightTask.task.value
	}

	func upgradeRefreshIntent(for key: String) async {
		guard let existing = tasks[key], existing.requiresRefresh == false else {
			return
		}

		tasks[key] = InFlightTask(
			id: existing.id,
			task: existing.task,
			requiresRefresh: true
		)
	}

	private func clearTask(
		for key: String,
		taskId: UUID
	) {
		guard let storedTask = tasks[key], storedTask.id == taskId else {
			return
		}
		tasks[key] = nil
	}
}
