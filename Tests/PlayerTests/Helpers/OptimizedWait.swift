import Foundation
@testable import Player
import Testing

func optimizedWait(timeout: Double = 10.0, step: Double = 0.1, until condition: () -> Bool) {
	var timer: Double = 0
	while timer < timeout {
		Thread.sleep(forTimeInterval: step)

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
