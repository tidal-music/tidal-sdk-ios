import Common
import Foundation

@available(*, deprecated, message: "Use Set<String> instead")
public struct Scopes: Codable, Hashable {
	public let scopes: Set<String>

	public init(scopes: Set<String>) {
		self.scopes = scopes
	}

	public init() {
		scopes = []
	}

	func toString() -> String {
		scopes.joined(separator: " ")
	}

	static func fromString(_ scopesString: String) throws -> Scopes {
		if scopesString.isEmpty {
			return Scopes(scopes: [])
		}

		return Scopes(scopes: Set(scopesString.split(separator: " ").map { String($0) }))
	}
}
