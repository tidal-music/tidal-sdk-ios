@testable import Player

extension Action {
	static func mock(
		actionType: ActionType = .PLAYBACK_START,
		assetPosition: Double = 0,
		timestamp: UInt64 = 0
	) -> Self {
		Action(actionType: actionType, assetPosition: assetPosition, timestamp: timestamp)
	}
}
