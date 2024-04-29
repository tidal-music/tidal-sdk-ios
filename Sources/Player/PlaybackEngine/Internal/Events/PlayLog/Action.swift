import Foundation

struct Action: Codable, Equatable {
	let actionType: ActionType
	let assetPosition: Double
	let timestamp: UInt64
}
