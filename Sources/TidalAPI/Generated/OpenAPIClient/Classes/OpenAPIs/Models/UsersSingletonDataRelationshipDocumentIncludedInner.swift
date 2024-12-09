import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UsersSingletonDataRelationshipDocumentIncludedInner

public enum UsersSingletonDataRelationshipDocumentIncludedInner: Codable, JSONEncodable, Hashable {
	case typeUserEntitlementsResource(UserEntitlementsResource)
	case typeUserPublicProfilesResource(UserPublicProfilesResource)
	case typeUserRecommendationsResource(UserRecommendationsResource)
	case typeUsersResource(UsersResource)

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case let .typeUserEntitlementsResource(value):
			try container.encode(value)
		case let .typeUserPublicProfilesResource(value):
			try container.encode(value)
		case let .typeUserRecommendationsResource(value):
			try container.encode(value)
		case let .typeUsersResource(value):
			try container.encode(value)
		}
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let value = try? container.decode(UserEntitlementsResource.self) {
			self = .typeUserEntitlementsResource(value)
		} else if let value = try? container.decode(UserPublicProfilesResource.self) {
			self = .typeUserPublicProfilesResource(value)
		} else if let value = try? container.decode(UserRecommendationsResource.self) {
			self = .typeUserRecommendationsResource(value)
		} else if let value = try? container.decode(UsersResource.self) {
			self = .typeUsersResource(value)
		} else {
			throw DecodingError.typeMismatch(
				Self.Type.self,
				.init(
					codingPath: decoder.codingPath,
					debugDescription: "Unable to decode instance of UsersSingletonDataRelationshipDocumentIncludedInner"
				)
			)
		}
	}
}
