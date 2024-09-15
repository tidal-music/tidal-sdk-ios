protocol AsyncSchedulerFactory {
	@discardableResult
	func create(code: @escaping () async -> Void) -> AsyncScheduler
}
