public extension AsyncSchedulerFactoryProvider {
	static let live = AsyncSchedulerFactoryProvider(
		newFactory: { TaskAsyncSchedulerFactory() }
	)
}
