import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - PlaylistsSingleDataDocumentIncludedInner

public enum PlaylistsSingleDataDocumentIncludedInner: Codable, JSONEncodable, Hashable {
	case typeArtistsResource(ArtistsResource)
	case typeTracksResource(TracksResource)
	case typeUsersResource(UsersResource)
	case typeVideosResource(VideosResource)

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case let .typeArtistsResource(value):
			try container.encode(value)
		case let .typeTracksResource(value):
			try container.encode(value)
		case let .typeUsersResource(value):
			try container.encode(value)
		case let .typeVideosResource(value):
			try container.encode(value)
		}
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let value = try? container.decode(ArtistsResource.self) {
			self = .typeArtistsResource(value)
		} else if let value = try? container.decode(TracksResource.self) {
			self = .typeTracksResource(value)
		} else if let value = try? container.decode(UsersResource.self) {
			self = .typeUsersResource(value)
		} else if let value = try? container.decode(VideosResource.self) {
			self = .typeVideosResource(value)
		} else {
			throw DecodingError.typeMismatch(
				Self.Type.self,
				.init(
					codingPath: decoder.codingPath,
					debugDescription: "Unable to decode instance of PlaylistsSingleDataDocumentIncludedInner"
				)
			)
		}
	}
}
