import Foundation
@testable import Player
import Testing

func optimizedWait(timeout: Double = 10.0, step: Double = 0.1, until condition: () -> Bool) {
	var timer: Double = 0
	while timer < timeout {
		// Pump the run loop (like XCTWaiter did) so run-loop scheduled work can fire while waiting.
		// With no attached sources, run(until:) returns immediately, so sleep out the rest of the step.
		let deadline = Date(timeIntervalSinceNow: step)
		RunLoop.current.run(until: deadline)
		if deadline.timeIntervalSinceNow > 0 {
			Thread.sleep(forTimeInterval: deadline.timeIntervalSinceNow)
		}

		if condition() {
			return
		}

		timer += step
	}

	Issue.record("Optimized wait: Condition was not met")
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

	Issue.record("Optimized wait: Condition was not met")
}
