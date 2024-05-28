import Common
import Foundation

// MARK: - RetryPolicy

protocol RetryPolicy {
	/// The maximum number of attempts after the first call
	var numberOfRetries: Int { get }

	/// The base delay to wait between retries
	var delayMillis: Int { get }

	/// The factor by which [delayMillis] gets multiplied for each following attempt
	var delayFactor: Int { get }

	/// The default implementation for retry-on-exception evaluation will return true only on
	/// server errors (5xx)This is the default because it is the behaviour
	/// needed for most calls in the authentication context.
	/// Override for different behaviour.
	func shouldRetryOnException(throwable: Error) -> Bool

	func shouldRetryOnErrorResponse(errorResponse: ErrorResponse?) -> Bool

	/// The default implementation for retry returns true if the submitted throwable is null
	/// or [shouldRetryOnException] evaluates to true, and the attempt count submitted is
	/// below the [numberOfRetries] threshold. Override for different behaviour.
	func shouldRetry(errorResponse: ErrorResponse?, throwable: Error?, attempt: Int) -> Bool
}

extension RetryPolicy {
	/// The default implementation for retry-on-exception evaluation will return true only on
	/// server errors (5xx)This is the default because it is the behaviour
	/// needed for most calls in the authentication context.
	/// Override for different behaviour.
	func shouldRetryOnException(throwable: Error) -> Bool {
		(throwable as? NetworkError)?.isServerError ?? false
	}

	func shouldRetryOnErrorResponse(errorResponse: ErrorResponse?) -> Bool {
		errorResponse?.status.isServerError == true
	}

	/// The default implementation for retry returns true if the submitted throwable is null
	/// or [shouldRetryOnException] evaluates to true, and the attempt count submitted is
	/// below the [numberOfRetries] threshold. Override for different behaviour.
	func shouldRetry(errorResponse: ErrorResponse?, throwable: Error?, attempt: Int) -> Bool {
		if let throwable, !shouldRetryOnException(throwable: throwable),
		   !shouldRetryOnErrorResponse(errorResponse: errorResponse)
		{
			return false
		}

		return attempt <= numberOfRetries
	}
}

// MARK: - DefaultRetryPolicy

struct DefaultRetryPolicy: RetryPolicy {
	var numberOfRetries: Int { 5 }
	var delayMillis: Int { 1000 }
	var delayFactor: Int { 2 }
}

// MARK: - UpgradeTokenRetryPolicy

struct UpgradeTokenRetryPolicy: RetryPolicy {
	var numberOfRetries: Int { 5 }
	var delayMillis: Int { 1000 }
	var delayFactor: Int { 2 }

	func shouldRetryOnException(throwable: Error) -> Bool {
		true
	}

	func shouldRetryOnErrorResponse(errorResponse: ErrorResponse?) -> Bool {
		true
	}
}
