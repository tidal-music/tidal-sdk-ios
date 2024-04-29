import Foundation

struct Stall: Codable, Equatable {
	var reason: StallReason
	var assetPosition: Double
	var startTimestamp: UInt64
	var endTimestamp: UInt64
}
