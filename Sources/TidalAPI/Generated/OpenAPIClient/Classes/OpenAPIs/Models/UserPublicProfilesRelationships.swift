import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserPublicProfilesRelationships

public struct UserPublicProfilesRelationships: Codable, Hashable {
	public var followers: MultiDataRelationshipDoc
	public var following: MultiDataRelationshipDoc
	public var publicPlaylists: MultiDataRelationshipDoc
	public var publicPicks: MultiDataRelationshipDoc

	public init(
		followers: MultiDataRelationshipDoc,
		following: MultiDataRelationshipDoc,
		publicPlaylists: MultiDataRelationshipDoc,
		publicPicks: MultiDataRelationshipDoc
	) {
		self.followers = followers
		self.following = following
		self.publicPlaylists = publicPlaylists
		self.publicPicks = publicPicks
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case followers
		case following
		case publicPlaylists
		case publicPicks
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(followers, forKey: .followers)
		try container.encode(following, forKey: .following)
		try container.encode(publicPlaylists, forKey: .publicPlaylists)
		try container.encode(publicPicks, forKey: .publicPicks)
	}
}
