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
		if let existing = tasks[key] {
			return try await existing.task.value
		}

		let task = Task.detached(priority: nil) {
			try await operation()
		}
		let inFlightTask = InFlightTask(task: task)
		tasks[key] = inFlightTask

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
