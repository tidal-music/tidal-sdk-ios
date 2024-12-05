import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserPublicProfilePicksRelationships

public struct UserPublicProfilePicksRelationships: Codable, Hashable {
	public var userPublicProfile: SingletonDataRelationshipDoc
	public var item: SingletonDataRelationshipDoc

	public init(userPublicProfile: SingletonDataRelationshipDoc, item: SingletonDataRelationshipDoc) {
		self.userPublicProfile = userPublicProfile
		self.item = item
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case userPublicProfile
		case item
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(userPublicProfile, forKey: .userPublicProfile)
		try container.encode(item, forKey: .item)
	}
}
