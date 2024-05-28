@testable import Player

extension [Action] {
	/// Compares two arrays of Actions and returns true if they are equal (accepting only a negligible time difference between both
	/// ``assetPosition`` from ``Action``),
	/// false otherwise.
	func isEqual(to anotherArray: [Action]) -> Bool {
		guard count == anotherArray.count else {
			return false
		}

		for (item, anotherItem) in zip(self, anotherArray) where !item.isEqual(anotherAction: anotherItem) {
			return false
		}

		return true
	}
}

/// Compares two Actions and returns true if they are equal (taking in consideration a negligible difference between the asset
/// position of both items), false otherwise.
private extension Action {
	func isEqual(anotherAction: Action) -> Bool {
		actionType == anotherAction.actionType
			&& timestamp == anotherAction.timestamp
			&& PlayLogTestsHelper.isTimeDifferenceNegligible(
				assetPosition: assetPosition,
				anotherAssetPosition: anotherAction.assetPosition
			)
	}
}
