import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UsersAttributes

public struct UsersAttributes: Codable, Hashable {
	/// user name
	public var username: String
	/// ISO 3166-1 alpha-2 country code
	public var country: String
	/// email address
	public var email: String?
	/// Is the email verified
	public var emailVerified: Bool?
	/// Users first name
	public var firstName: String?
	/// Users last name
	public var lastName: String?

	public init(
		username: String,
		country: String,
		email: String? = nil,
		emailVerified: Bool? = nil,
		firstName: String? = nil,
		lastName: String? = nil
	) {
		self.username = username
		self.country = country
		self.email = email
		self.emailVerified = emailVerified
		self.firstName = firstName
		self.lastName = lastName
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case username
		case country
		case email
		case emailVerified
		case firstName
		case lastName
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(username, forKey: .username)
		try container.encode(country, forKey: .country)
		try container.encodeIfPresent(email, forKey: .email)
		try container.encodeIfPresent(emailVerified, forKey: .emailVerified)
		try container.encodeIfPresent(firstName, forKey: .firstName)
		try container.encodeIfPresent(lastName, forKey: .lastName)
	}
}
