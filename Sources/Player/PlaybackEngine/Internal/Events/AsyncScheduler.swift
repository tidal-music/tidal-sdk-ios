protocol AsyncScheduler {
  static func schedule(code: @escaping () async -> Void) -> AsyncScheduler
}

protocol AsyncSchedulerFactory {
  @discardableResult
  func create(code: @escaping () async -> Void) -> AsyncScheduler
}

extension Task: AsyncScheduler {
  static func schedule(code: @escaping () async -> Void) -> AsyncScheduler {
	Task<Void, Never> {
	  await code()
	}
  }
}

class TaskAsyncSchedulerFactory: AsyncSchedulerFactory {
  @discardableResult
  func create(code: @escaping () async -> Void) -> AsyncScheduler {
	Task<Void, Never>.schedule(code: code)
  }
}
