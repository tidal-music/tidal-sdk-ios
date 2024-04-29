import Foundation
@testable import Player

final class BackoffPolicyMock: BackoffPolicy {
	var counter: Int = 0

	func onFailedAttempt(attemptCount: Int) -> TimeInterval {
		counter += 1
		return 0
	}
}
