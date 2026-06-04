import Foundation
@testable import Player
import Testing

struct BackoffPolicyTests {
	@Test
	func testDefaultBackoffPolicy_expectedValues_default() {
		let policy = StandardBackoffPolicy.standard
		let expectedValues: [Double] = [0.5, 1, 2, 4, 8, 16, 16, 16, 16, 16]
		for attempt in 0 ..< 10 {
			let delay = policy.onFailedAttempt(attemptCount: attempt)
			#expect(delay == expectedValues[attempt])
		}
	}

	@Test
	func testDefaultBackoffPolicy_expectedValues_network() {
		let policy = StandardBackoffPolicy.forNetworkErrors
		let expectedValues: [Double] = [1, 2, 4, 8, 16, 16, 16, 16, 16, 16]
		for attempt in 0 ..< 10 {
			let delay = policy.onFailedAttempt(attemptCount: attempt)
			#expect(delay == expectedValues[attempt])
		}
	}

	@Test
	func testDefaultBackoffPolicy_expectedValues_timeout() {
		let policy = StandardBackoffPolicy.forTimeoutErrors
		let expectedValues: [Double] = [2, 4, 8, 16, 32, 32, 32, 32, 32, 32]
		for attempt in 0 ..< 10 {
			let delay = policy.onFailedAttempt(attemptCount: attempt)
			#expect(delay == expectedValues[attempt])
		}
	}

	@Test
	func testJitteredBackoffPolicy_expectedValues_default() {
		let policy = JitteredBackoffPolicy.standard
		let expectedMaxValues: [Double] = [0.5, 1, 2, 4, 8, 16, 16, 16, 16, 16]
		for attempt in 0 ..< 10 {
			for _ in 0 ... 100 { // Due to randomized jitter
				let delay = policy.onFailedAttempt(attemptCount: attempt)
				#expect(delay <= expectedMaxValues[attempt])
			}
		}
	}

	@Test
	func testJitteredBackoffPolicy_expectedValues_network() {
		let policy = JitteredBackoffPolicy.forNetworkErrors
		let expectedMaxValues: [Double] = [1, 2, 4, 8, 16, 16, 16, 16, 16, 16]
		for attempt in 0 ..< 10 {
			for _ in 0 ... 100 { // Due to randomized jitter
				let delay = policy.onFailedAttempt(attemptCount: attempt)
				#expect(delay <= expectedMaxValues[attempt])
			}
		}
	}

	@Test
	func testJitteredBackoffPolicy_expectedValues_timeout() {
		let policy = JitteredBackoffPolicy.forTimeoutErrors
		let expectedMaxValues: [Double] = [8, 16, 32, 32, 32, 32, 32, 32, 32, 32]
		for attempt in 0 ..< 10 {
			for _ in 0 ... 100 { // Due to randomized jitter
				let delay = policy.onFailedAttempt(attemptCount: attempt)
				#expect(delay <= expectedMaxValues[attempt])
			}
		}
	}
}
