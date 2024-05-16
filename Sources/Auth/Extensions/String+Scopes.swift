import Foundation

extension String {
	private static let separator: Self.Element = " "

	func toScopes() -> Set<String> {
		Set(
			self.split(separator: Self.separator)
				.map { String($0) }
		)
	}

	init(scopes: Set<String>) {
		self = scopes.joined(separator: String(Self.separator))
	}
}
