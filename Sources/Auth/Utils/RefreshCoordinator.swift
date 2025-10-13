import Foundation

protocol RefreshCoalescing {
	func runOrJoinCredentials(
		key: String,
		operation: @Sendable @escaping () async throws -> AuthResult<Credentials>
	) async throws -> AuthResult<Credentials>
}

actor RefreshCoordinator: RefreshCoalescing {
	private struct InFlightTask {
		let id = UUID()
		let task: Task<AuthResult<Credentials>, Error>
	}

	private var tasks: [String: InFlightTask] = [:]

	func runOrJoinCredentials(
		key: String,
		operation: @Sendable @escaping () async throws -> AuthResult<Credentials>
	) async throws -> AuthResult<Credentials> {
		// If a task is already in-flight for this key, join it instead of creating a new one
		if let existing = tasks[key] {
			return try await existing.task.value
		}

		// Create a new detached task to perform the operation
		let task = Task.detached(priority: nil) {
			try await operation()
		}
		let inFlightTask = InFlightTask(task: task)
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
