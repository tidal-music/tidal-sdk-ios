extension AsyncSchedulerFactoryProvider {
	public static let live = AsyncSchedulerFactoryProvider(
		newFactory: { TaskAsyncSchedulerFactory() }
	)
}
