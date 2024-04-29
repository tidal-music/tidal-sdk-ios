import Foundation

class BaseErrorManager {
	let maxErrorRetryAttempts: Int
	let backoffPolicy: BackoffPolicy

	init(maxRetryAttempts: Int, backoffPolicy: BackoffPolicy) {
		maxErrorRetryAttempts = maxRetryAttempts
		self.backoffPolicy = backoffPolicy
	}
}
