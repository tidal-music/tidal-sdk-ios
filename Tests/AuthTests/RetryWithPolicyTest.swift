@testable import Auth
import Common
import XCTest

// MARK: - RetryWithPolicyTest

final class RetryWithPolicyTest: XCTestCase {
	func testRetryDefinedNumberOfTimesWhenReceivingServerErrors() async throws {
		// given
		struct TestPolicy: RetryPolicy {
			var numberOfRetries: Int { 5 }
			var delayMillis: Int { 1 }
			var delayFactor: Int { 1 }
		}

		let testPolicy = TestPolicy()
		var attempts = 0
		let throwIt = {
			attempts += 1
			throw NetworkError(code: "503")
		}

		// when
		_ = await retryWithPolicy(testPolicy) {
			try throwIt()
			fatalError()
		}

		// then
		XCTAssertEqual(6, attempts, "The function should have made 6 attempts (1 + 5 retries)")
	}

	func testStopRetryingOnNonServerErrors() async throws {
		// given
		struct TestPolicy: RetryPolicy {
			var numberOfRetries: Int { 5 }
			var delayMillis: Int { 1 }
			var delayFactor: Int { 1 }
		}

		let testPolicy = TestPolicy()
		var attempts = 0
		let throwIt = {
			attempts += 1
			throw NetworkError(code: "401")
		}

		// when
		_ = await retryWithPolicy(testPolicy) {
			try throwIt()
			fatalError()
		}

		// then
		XCTAssertEqual(1, attempts, "The function should have made just 1 attempt")
	}

	func testRetryDefinedNumberOfTimesWhileCustomShouldRetryFunctionTrue() async throws {
		// given
		struct TestPolicy: RetryPolicy {
			var numberOfRetries: Int { 5 }
			var delayMillis: Int { 1 }
			var delayFactor: Int { 1 }

			func shouldRetryOnException(throwable: Error) -> Bool {
				(throwable as? NetworkError)?.code == "\(errorCode999)"
			}
		}

		let testPolicy = TestPolicy()

		var attempts = 0
		let throwIt = {
			attempts += 1
			throw NetworkError(code: "\(errorCode999)")
		}

		// when
		_ = await retryWithPolicy(testPolicy) {
			try throwIt()
			fatalError()
		}

		// then
		XCTAssertEqual(6, attempts, "The function should have made 6 attempts (1 + 5 retries)")
	}
}

private let errorCode999 = 999
