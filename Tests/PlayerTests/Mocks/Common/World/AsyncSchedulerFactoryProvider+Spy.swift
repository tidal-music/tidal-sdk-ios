import Foundation
@testable import Player

// swiftformat:disable:next extensionAccessControl
extension AsyncSchedulerFactoryProvider {
	public static let spy = AsyncSchedulerFactoryProvider(
		newFactory: { AsyncSchedulerFactorySpy() }
	)
}
