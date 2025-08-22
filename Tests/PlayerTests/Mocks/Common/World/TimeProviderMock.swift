import Foundation
@testable import Player

/// Mock implementation of TimeProvider for testing.
struct TimeProviderMock {
    var mockTimestamp: UInt64 = 0
    var mockDate: Date = Date()
}

extension TimeProviderMock {
    static func createMock() -> TimeProvider {
        let mock = TimeProviderMock()
        return TimeProvider(
            timestamp: { mock.mockTimestamp },
            date: { mock.mockDate }
        )
    }
}