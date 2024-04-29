import Foundation

// MARK: - TimeProvider

struct TimeProvider {
	var timestamp: () -> UInt64
	var date: () -> Date
}

extension TimeProvider {
	static let live: Self = TimeProvider(
		timestamp: { Time.now() },
		date: { Time.date() }
	)
}
