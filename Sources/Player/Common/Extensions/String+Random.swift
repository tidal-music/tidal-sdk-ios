import Foundation

extension String {
	static func random(length: Int) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

		return String((0 ..< length).compactMap { _ in
			letters.randomElement()
		})
	}
}
