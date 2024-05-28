@testable import Player

extension Stall {
	static func mock(
		reason: StallReason = .SEEK,
		assetPosition: Double = 0,
		startTimestamp: UInt64 = 0,
		endTimestamp: UInt64 = 0
	) -> Self {
		Stall(reason: reason, assetPosition: assetPosition, startTimestamp: startTimestamp, endTimestamp: endTimestamp)
	}
}
