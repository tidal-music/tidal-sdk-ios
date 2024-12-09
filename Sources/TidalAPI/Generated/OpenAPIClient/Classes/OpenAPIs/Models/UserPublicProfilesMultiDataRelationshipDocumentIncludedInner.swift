import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserPublicProfilesMultiDataRelationshipDocumentIncludedInner

public enum UserPublicProfilesMultiDataRelationshipDocumentIncludedInner: Codable, JSONEncodable, Hashable {
	case typeArtistsResource(ArtistsResource)
	case typePlaylistsResource(PlaylistsResource)
	case typeUserPublicProfilePicksResource(UserPublicProfilePicksResource)
	case typeUserPublicProfilesResource(UserPublicProfilesResource)
	case typeUsersResource(UsersResource)

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case let .typeArtistsResource(value):
			try container.encode(value)
		case let .typePlaylistsResource(value):
			try container.encode(value)
		case let .typeUserPublicProfilePicksResource(value):
			try container.encode(value)
		case let .typeUserPublicProfilesResource(value):
			try container.encode(value)
		case let .typeUsersResource(value):
			try container.encode(value)
		}
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let value = try? container.decode(ArtistsResource.self) {
			self = .typeArtistsResource(value)
		} else if let value = try? container.decode(PlaylistsResource.self) {
			self = .typePlaylistsResource(value)
		} else if let value = try? container.decode(UserPublicProfilePicksResource.self) {
			self = .typeUserPublicProfilePicksResource(value)
		} else if let value = try? container.decode(UserPublicProfilesResource.self) {
			self = .typeUserPublicProfilesResource(value)
		} else if let value = try? container.decode(UsersResource.self) {
			self = .typeUsersResource(value)
		} else {
			throw DecodingError.typeMismatch(
				Self.Type.self,
				.init(
					codingPath: decoder.codingPath,
					debugDescription: "Unable to decode instance of UserPublicProfilesMultiDataRelationshipDocumentIncludedInner"
				)
			)
		}
	}
}
