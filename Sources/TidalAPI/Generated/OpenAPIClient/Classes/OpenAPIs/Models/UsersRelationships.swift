import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UsersRelationships

public struct UsersRelationships: Codable, Hashable {
	public var entitlements: SingletonDataRelationshipDoc
	public var publicProfile: SingletonDataRelationshipDoc
	public var recommendations: SingletonDataRelationshipDoc

	public init(
		entitlements: SingletonDataRelationshipDoc,
		publicProfile: SingletonDataRelationshipDoc,
		recommendations: SingletonDataRelationshipDoc
	) {
		self.entitlements = entitlements
		self.publicProfile = publicProfile
		self.recommendations = recommendations
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case entitlements
		case publicProfile
		case recommendations
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(entitlements, forKey: .entitlements)
		try container.encode(publicProfile, forKey: .publicProfile)
		try container.encode(recommendations, forKey: .recommendations)
	}
}
