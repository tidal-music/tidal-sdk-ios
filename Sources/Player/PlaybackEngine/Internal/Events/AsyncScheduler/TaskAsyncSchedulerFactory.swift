import Foundation

final class TaskAsyncSchedulerFactory: AsyncSchedulerFactory {
	@discardableResult
	func create(code: @escaping () async -> Void) -> AsyncScheduler {
		Task<Void, Never>.schedule(code: code)
	}
}
