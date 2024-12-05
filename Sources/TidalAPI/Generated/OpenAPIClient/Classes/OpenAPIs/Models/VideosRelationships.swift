import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - VideosRelationships

public struct VideosRelationships: Codable, Hashable {
	public var albums: MultiDataRelationshipDoc
	public var artists: MultiDataRelationshipDoc
	public var providers: MultiDataRelationshipDoc

	public init(albums: MultiDataRelationshipDoc, artists: MultiDataRelationshipDoc, providers: MultiDataRelationshipDoc) {
		self.albums = albums
		self.artists = artists
		self.providers = providers
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case albums
		case artists
		case providers
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(albums, forKey: .albums)
		try container.encode(artists, forKey: .artists)
		try container.encode(providers, forKey: .providers)
	}
}
