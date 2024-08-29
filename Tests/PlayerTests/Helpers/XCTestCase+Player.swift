import Foundation
@testable import Player
import XCTest

extension XCTestCase {
	func optimizedWait(timeout: Double = 10.0, step: Double = 0.1, description: String, until condition: @escaping () -> Bool) {
		let endTime = Date().addingTimeInterval(timeout)

		while Date() < endTime {
			if condition() {
				return
			}

			let expectation = expectation(description: "Optimized wait: Waiting for condition to be met")
			let result = XCTWaiter.wait(for: [expectation], timeout: step)

			if result != .timedOut {
				XCTFail("Optimized wait: Unexpected result from XCTWaiter. Failed to fulfill condition: \(description)")
				return
			}
		}

		XCTFail("Optimized wait: Condition was not met. Failed to fulfill condition: \(description)")
	}

	func asyncOptimizedWait(timeout: Double = 10.0, step: Double = 0.1, until condition: @escaping () -> Bool) async {
		let endTime = Date().addingTimeInterval(timeout)

		while Date() < endTime {
			do {
				try await Task.sleep(nanoseconds: UInt64(step * 1_000_000_000))
			} catch {
				XCTFail("Optimized wait: Task was interrupted")
				return
			}

			if condition() {
				return
			}

			if Task.isCancelled {
				XCTFail("Optimized wait: Task was cancelled")
				return
			}
		}

		XCTFail("Optimized wait: Condition was not met")
	}
}
