import Foundation

/// - Important: If more properties are added, you might want to consider updating play log tests accordingly.
struct Action: Codable, Equatable {
	let actionType: ActionType
	let assetPosition: Double
	let timestamp: UInt64
}
