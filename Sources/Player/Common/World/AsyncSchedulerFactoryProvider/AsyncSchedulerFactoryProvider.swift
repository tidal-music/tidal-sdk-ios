import Foundation

/// Provider of AsyncSchedulerFactory used to dispatch Tasks in a controlled way.

struct AsyncSchedulerFactoryProvider {
	var newFactory: () -> AsyncSchedulerFactory
}
