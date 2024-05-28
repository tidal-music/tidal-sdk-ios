import Foundation

// MARK: - JitteredBackoffPolicy

struct JitteredBackoffPolicy: BackoffPolicy {
	private let baseDelayInS: TimeInterval
	private let maxBackoffDelayInS: TimeInterval
	private let maxJitterFactor: Double

	init(baseDelayInS: TimeInterval, maxDelayInS: TimeInterval, jitterFactor: Double = 0.2) {
		self.baseDelayInS = baseDelayInS
		maxBackoffDelayInS = maxDelayInS
		maxJitterFactor = jitterFactor
	}

	func onFailedAttempt(attemptCount: Int) -> TimeInterval {
		let exponentialDelayInMs = (baseDelayInS * 1000) * pow(2.0, Double(attemptCount))
		let cappedDelayInMs = min(exponentialDelayInMs, maxBackoffDelayInS * 1000)
		let jitterFactor = Double(Int.random(in: 0 ... 100)) / Double(100) * maxJitterFactor
		let adjustedDelayInMs = (cappedDelayInMs * (1 - maxJitterFactor + jitterFactor))
		let delayInS = adjustedDelayInMs / 1000
		return delayInS
	}
}

// MARK: - Convenience

extension JitteredBackoffPolicy {
	static var standard: JitteredBackoffPolicy {
		JitteredBackoffPolicy(baseDelayInS: 0.5, maxDelayInS: 16)
	}

	static var forNetworkErrors: JitteredBackoffPolicy {
		JitteredBackoffPolicy(baseDelayInS: 1, maxDelayInS: 16)
	}

	static var forTimeoutErrors: JitteredBackoffPolicy {
		JitteredBackoffPolicy(baseDelayInS: 8, maxDelayInS: 32)
	}

	/// Backoff policy to be used in the web socket connection: base is 1s, max is 60s and jitter factor is 0.2.
	static var webSocketBackoffPolicy: JitteredBackoffPolicy {
		JitteredBackoffPolicy(baseDelayInS: 1, maxDelayInS: 60)
	}
}
