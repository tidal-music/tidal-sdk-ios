import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserPublicProfilePicksSingletonDataRelationshipDocumentIncludedInner

public enum UserPublicProfilePicksSingletonDataRelationshipDocumentIncludedInner: Codable, JSONEncodable, Hashable {
	case typeAlbumsResource(AlbumsResource)
	case typeArtistsResource(ArtistsResource)
	case typeTracksResource(TracksResource)
	case typeUserPublicProfilePicksResource(UserPublicProfilePicksResource)
	case typeUserPublicProfilesResource(UserPublicProfilesResource)

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case let .typeAlbumsResource(value):
			try container.encode(value)
		case let .typeArtistsResource(value):
			try container.encode(value)
		case let .typeTracksResource(value):
			try container.encode(value)
		case let .typeUserPublicProfilePicksResource(value):
			try container.encode(value)
		case let .typeUserPublicProfilesResource(value):
			try container.encode(value)
		}
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let value = try? container.decode(AlbumsResource.self) {
			self = .typeAlbumsResource(value)
		} else if let value = try? container.decode(ArtistsResource.self) {
			self = .typeArtistsResource(value)
		} else if let value = try? container.decode(TracksResource.self) {
			self = .typeTracksResource(value)
		} else if let value = try? container.decode(UserPublicProfilePicksResource.self) {
			self = .typeUserPublicProfilePicksResource(value)
		} else if let value = try? container.decode(UserPublicProfilesResource.self) {
			self = .typeUserPublicProfilesResource(value)
		} else {
			throw DecodingError.typeMismatch(
				Self.Type.self,
				.init(
					codingPath: decoder.codingPath,
					debugDescription: "Unable to decode instance of UserPublicProfilePicksSingletonDataRelationshipDocumentIncludedInner"
				)
			)
		}
	}
}
