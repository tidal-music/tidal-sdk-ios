import Foundation
@testable import Player

final class ErrorManagerMock: ErrorManager {
	private(set) var errors = [Error]()
	private(set) var attemptCounts = [Int]()
	var retryStrategy = RetryStrategy.NONE

	func onError(_ error: Error, attemptCount: Int) -> RetryStrategy {
		errors.append(error)
		attemptCounts.append(attemptCount)

		return retryStrategy
	}
}
