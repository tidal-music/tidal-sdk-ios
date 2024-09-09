import Foundation
@testable import Player

public extension AsyncSchedulerFactoryProvider {
	static let spy = AsyncSchedulerFactoryProvider(
		newFactory: { AsyncSchedulerFactorySpy() }
	)
}
