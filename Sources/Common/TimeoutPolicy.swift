import Foundation

public struct TimeoutPolicy {
	public let requestTimeout: TimeInterval
	public let resourceTimeout: TimeInterval

	public init(requestTimeout: TimeInterval, resourceTimeout: TimeInterval) {
		self.requestTimeout = requestTimeout
		self.resourceTimeout = resourceTimeout
	}

	public static var standard: TimeoutPolicy {
		TimeoutPolicy(requestTimeout: 15, resourceTimeout: 30)
	}

	public static var shortLived: TimeoutPolicy {
		TimeoutPolicy(requestTimeout: 5, resourceTimeout: 5)
	}

	public static var longLived: TimeoutPolicy {
		TimeoutPolicy(requestTimeout: 60, resourceTimeout: 60 * 10)
	}
}
