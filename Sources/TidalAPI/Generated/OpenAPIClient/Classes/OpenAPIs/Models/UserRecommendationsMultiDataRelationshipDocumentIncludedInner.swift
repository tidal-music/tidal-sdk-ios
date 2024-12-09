import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserRecommendationsMultiDataRelationshipDocumentIncludedInner

public enum UserRecommendationsMultiDataRelationshipDocumentIncludedInner: Codable, JSONEncodable, Hashable {
	case typePlaylistsResource(PlaylistsResource)
	case typeUserRecommendationsResource(UserRecommendationsResource)

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case let .typePlaylistsResource(value):
			try container.encode(value)
		case let .typeUserRecommendationsResource(value):
			try container.encode(value)
		}
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let value = try? container.decode(PlaylistsResource.self) {
			self = .typePlaylistsResource(value)
		} else if let value = try? container.decode(UserRecommendationsResource.self) {
			self = .typeUserRecommendationsResource(value)
		} else {
			throw DecodingError.typeMismatch(
				Self.Type.self,
				.init(
					codingPath: decoder.codingPath,
					debugDescription: "Unable to decode instance of UserRecommendationsMultiDataRelationshipDocumentIncludedInner"
				)
			)
		}
	}
}
