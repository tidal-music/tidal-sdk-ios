import Foundation
@testable import Player

extension TimeProvider {
	static let mock: Self = TimeProvider(
		timestamp: { 1 },
		date: { Date() }
	)

	static func mock(
		timestamp: @escaping (() -> UInt64) = { 1 },
		date: @escaping (() -> Date) = { Date() }
	) -> Self {
		TimeProvider(timestamp: timestamp, date: date)
	}
}
