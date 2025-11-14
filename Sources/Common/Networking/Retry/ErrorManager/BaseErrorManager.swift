import Foundation

open class BaseErrorManager {
	public let maxErrorRetryAttempts: Int
	public let backoffPolicy: BackoffPolicy

	public init(maxRetryAttempts: Int, backoffPolicy: BackoffPolicy) {
		maxErrorRetryAttempts = maxRetryAttempts
		self.backoffPolicy = backoffPolicy
	}
}
