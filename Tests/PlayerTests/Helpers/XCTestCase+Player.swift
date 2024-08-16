import Foundation
@testable import Player
import XCTest

extension XCTestCase {
	func optimizedWait(timeout: Double = 10.0, step: Double = 0.1, until condition: @escaping () -> Bool) {
		let endTime = Date().addingTimeInterval(timeout)

		while Date() < endTime {
			if condition() {
				return
			}

			let expectation = expectation(description: "Optimized wait: Waiting for condition to be met")
			let result = XCTWaiter.wait(for: [expectation], timeout: step)

			if result != .timedOut {
				XCTFail("Optimized wait: Unexpected result from XCTWaiter")
				return
			}
		}

		XCTFail("Optimized wait: Condition was not met")
	}

	func asyncOptimizedWait(timeout: Double = 10.0, step: Double = 0.1, until condition: @escaping () -> Bool) async {
		var timer: Double = 0
		while timer < timeout {
			try? await Task.sleep(seconds: step)

			if condition() {
				return
			}

			timer += step
		}

		XCTFail("Optimized wait: Condition was not met")
	}
}
