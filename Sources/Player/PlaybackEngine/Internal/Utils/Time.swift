import Foundation
import Kronos

enum Time {
	static func initialise() {
		// Initialise NTP clock time. Calling Clock.sync will fire a bunch of NTP requests to up to 5 of the servers on the given NTP
		// pool (default is time.apple.com).
		// As soon as we get the first response, the clock.now can give current date  but the Clock will keep trying to get a more
		// accurate response.
		Clock.sync()
	}

	static func now() -> UInt64 {
		let date = Clock.now ?? Date()
		return UInt64(date.timeIntervalSince1970 * 1000)
	}

	static func date() -> Date {
		Clock.now ?? Date()
	}
}
