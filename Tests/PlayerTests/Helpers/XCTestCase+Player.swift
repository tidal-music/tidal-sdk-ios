import Foundation
import XCTest

extension XCTestCase {
	func optimizedWait(timeout: Double = 10.0, step: Double = 0.1, until condition: () -> Bool) {
		var timer: Double = 0
		while timer < timeout {
			let expectation = expectation(description: "Optimized wait: Waiting for condition to be met")
			_ = XCTWaiter.wait(for: [expectation], timeout: step)

			if condition() {
				return
			}

			timer += step
		}

		XCTFail("Optimized wait: Condition was not met")
	}
}
