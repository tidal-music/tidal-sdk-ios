@testable import Player

extension PlayerEvent.Extras {
	static func mock() -> Self {
		[
			"string": "some-value",
			"none": nil,
			"boolean": true,
			"integer": 1,
			"double": 1.1,
			"array": ["value1", "value2"],
			"dictionary": [
				"key": "value",
				"anotherKey": 1,
				"yetAnotherKey": true,
				"nestedDictionary": ["nestedKey": "nestedValue"],
			],
		]
	}
}
