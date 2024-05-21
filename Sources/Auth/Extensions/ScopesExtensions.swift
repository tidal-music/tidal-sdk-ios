import Foundation

private let scopesSeparator: Character = " "

extension String {
	func toScopes() -> Set<String> {
		Set(
			self.split(separator: scopesSeparator)
				.map { String($0) }
		)
	}
}

extension Set<String> {
	func toScopesString() -> String {
		self.joined(separator: String(scopesSeparator))
	}
}
