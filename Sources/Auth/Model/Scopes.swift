import Common
import Foundation

public struct Scopes: Codable, Hashable {
	public let scopes: Set<String>

	public init(scopes: Set<String>) throws {
		if !scopes.isEmpty,
		   scopes.contains(where: { $0.range(of: Scopes.SINGLE_VALID_SCOPE_REGEX, options: .regularExpression) == nil })
		{
			throw TidalError(code: "-1", message: Scopes.ILLEGAL_SCOPES_MESSAGE)
		}

		self.scopes = scopes
	}

	public init() {
		scopes = []
	}

	func toString() -> String {
		scopes.joined(separator: " ")
	}

	/// Swift-Regex for the differs from Android: we add "^" & "$" for the whole string matching
	/// See more at: https://stackoverflow.com/a/43677202
	static let VALID_SCOPES_STRING_REGEX = "^([rw]_[a-z]+\\s)*[rw]_[a-z]+$"
	static let ILLEGAL_SCOPES_MESSAGE = "Submitted Scopes are invalid!"
	private static let SINGLE_VALID_SCOPE_REGEX = "^[rw]_[a-z]+$"

	static func fromString(_ scopesString: String) throws -> Scopes {
		if scopesString.isEmpty {
			return try Scopes(scopes: [])
		}

		if scopesString.range(of: VALID_SCOPES_STRING_REGEX, options: .regularExpression) != nil {
			return try Scopes(scopes: Set(scopesString.split(separator: " ").map { String($0) }))
		}

		throw TidalError(code: "-1", message: ILLEGAL_SCOPES_MESSAGE)
	}
}
