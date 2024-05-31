import Foundation
@testable import Player

extension AsyncSchedulerFactoryProvider {
	public static let spy = AsyncSchedulerFactoryProvider(
		newFactory: { AsyncSchedulerFactorySpy() }
	)
}
