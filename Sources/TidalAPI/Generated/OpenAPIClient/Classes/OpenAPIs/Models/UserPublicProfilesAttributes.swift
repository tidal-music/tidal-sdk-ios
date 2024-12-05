import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserPublicProfilesAttributes

public struct UserPublicProfilesAttributes: Codable, Hashable {
	/// A customizable handle for the user profile
	public var handle: String?
	/// Public Name of the user profile
	public var profileName: String?
	public var picture: UserPublicProfilesImageLink?
	public var color: [String]
	/// ExternalLinks for the user's profile
	public var externalLinks: [UserPublicProfilesExternalLink]?
	/// Number of followers for the user
	public var numberOfFollowers: Int?
	/// Number of users the user follows
	public var numberOfFollows: Int?

	public init(
		handle: String? = nil,
		profileName: String? = nil,
		picture: UserPublicProfilesImageLink? = nil,
		color: [String],
		externalLinks: [UserPublicProfilesExternalLink]? = nil,
		numberOfFollowers: Int? = nil,
		numberOfFollows: Int? = nil
	) {
		self.handle = handle
		self.profileName = profileName
		self.picture = picture
		self.color = color
		self.externalLinks = externalLinks
		self.numberOfFollowers = numberOfFollowers
		self.numberOfFollows = numberOfFollows
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case handle
		case profileName
		case picture
		case color
		case externalLinks
		case numberOfFollowers
		case numberOfFollows
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(handle, forKey: .handle)
		try container.encodeIfPresent(profileName, forKey: .profileName)
		try container.encodeIfPresent(picture, forKey: .picture)
		try container.encode(color, forKey: .color)
		try container.encodeIfPresent(externalLinks, forKey: .externalLinks)
		try container.encodeIfPresent(numberOfFollowers, forKey: .numberOfFollowers)
		try container.encodeIfPresent(numberOfFollows, forKey: .numberOfFollows)
	}
}
