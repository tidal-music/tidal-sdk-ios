import Foundation

private let scopesSeparator: Character = " "

extension String {
	func toScopes() -> Set<String> {
		Set(
			split(separator: scopesSeparator)
				.map { String($0) }
		)
	}
}

extension Set<String> {
	func toScopesString() -> String {
		joined(separator: String(scopesSeparator))
	}
}
