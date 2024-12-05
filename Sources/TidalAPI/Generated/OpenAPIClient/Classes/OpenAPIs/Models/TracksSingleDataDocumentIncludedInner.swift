import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - TracksSingleDataDocumentIncludedInner

public enum TracksSingleDataDocumentIncludedInner: Codable, JSONEncodable, Hashable {
	case typeAlbumsResource(AlbumsResource)
	case typeArtistsResource(ArtistsResource)
	case typePlaylistsResource(PlaylistsResource)
	case typeProvidersResource(ProvidersResource)
	case typeTracksResource(TracksResource)

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case let .typeAlbumsResource(value):
			try container.encode(value)
		case let .typeArtistsResource(value):
			try container.encode(value)
		case let .typePlaylistsResource(value):
			try container.encode(value)
		case let .typeProvidersResource(value):
			try container.encode(value)
		case let .typeTracksResource(value):
			try container.encode(value)
		}
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let value = try? container.decode(AlbumsResource.self) {
			self = .typeAlbumsResource(value)
		} else if let value = try? container.decode(ArtistsResource.self) {
			self = .typeArtistsResource(value)
		} else if let value = try? container.decode(PlaylistsResource.self) {
			self = .typePlaylistsResource(value)
		} else if let value = try? container.decode(ProvidersResource.self) {
			self = .typeProvidersResource(value)
		} else if let value = try? container.decode(TracksResource.self) {
			self = .typeTracksResource(value)
		} else {
			throw DecodingError.typeMismatch(
				Self.Type.self,
				.init(
					codingPath: decoder.codingPath,
					debugDescription: "Unable to decode instance of TracksSingleDataDocumentIncludedInner"
				)
			)
		}
	}
}
