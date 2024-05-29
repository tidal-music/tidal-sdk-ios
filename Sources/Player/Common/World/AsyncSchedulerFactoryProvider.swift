import Foundation

// MARK: - AsyncSchedulerFactoryProvider.swift

struct AsyncSchedulerFactoryProvider {
	var newFactory: () -> AsyncSchedulerFactory
}

extension AsyncSchedulerFactoryProvider {
	public static let live = AsyncSchedulerFactoryProvider(
		newFactory: { TaskAsyncSchedulerFactory() }
	)
}
