import Foundation

struct TimeoutPolicy {
	let requestTimeout: TimeInterval
	let resourceTimeout: TimeInterval

	static var standard: TimeoutPolicy {
		TimeoutPolicy(requestTimeout: 15, resourceTimeout: 30)
	}

	static var shortLived: TimeoutPolicy {
		TimeoutPolicy(requestTimeout: 5, resourceTimeout: 5)
	}

	static var longLived: TimeoutPolicy {
		TimeoutPolicy(requestTimeout: 60, resourceTimeout: 60 * 10)
	}
}
