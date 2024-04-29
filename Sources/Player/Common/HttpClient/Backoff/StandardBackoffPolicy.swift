import Foundation

struct StandardBackoffPolicy: BackoffPolicy {
	private let baseDelayInS: TimeInterval
	private let maxBackoffDelayInS: TimeInterval

	init(baseDelayInS: TimeInterval, maxDelayInS: TimeInterval) {
		self.baseDelayInS = baseDelayInS
		maxBackoffDelayInS = maxDelayInS
	}

	func onFailedAttempt(attemptCount: Int) -> TimeInterval {
		let delayInS = ((baseDelayInS * 1000) * pow(2.0, Double(attemptCount))) / 1000
		return min(delayInS, maxBackoffDelayInS)
	}

	static var standard: StandardBackoffPolicy {
		StandardBackoffPolicy(baseDelayInS: 0.5, maxDelayInS: 16)
	}

	static var forNetworkErrors: StandardBackoffPolicy {
		StandardBackoffPolicy(baseDelayInS: 1, maxDelayInS: 16)
	}

	static var forTimeoutErrors: StandardBackoffPolicy {
		StandardBackoffPolicy(baseDelayInS: 2, maxDelayInS: 32)
	}
}
