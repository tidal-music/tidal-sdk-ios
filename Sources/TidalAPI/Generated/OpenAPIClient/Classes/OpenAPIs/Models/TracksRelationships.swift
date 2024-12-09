import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - TracksRelationships

public struct TracksRelationships: Codable, Hashable {
	public var albums: MultiDataRelationshipDoc
	public var artists: MultiDataRelationshipDoc
	public var similarTracks: MultiDataRelationshipDoc
	public var providers: MultiDataRelationshipDoc
	public var radio: MultiDataRelationshipDoc

	public init(
		albums: MultiDataRelationshipDoc,
		artists: MultiDataRelationshipDoc,
		similarTracks: MultiDataRelationshipDoc,
		providers: MultiDataRelationshipDoc,
		radio: MultiDataRelationshipDoc
	) {
		self.albums = albums
		self.artists = artists
		self.similarTracks = similarTracks
		self.providers = providers
		self.radio = radio
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case albums
		case artists
		case similarTracks
		case providers
		case radio
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(albums, forKey: .albums)
		try container.encode(artists, forKey: .artists)
		try container.encode(similarTracks, forKey: .similarTracks)
		try container.encode(providers, forKey: .providers)
		try container.encode(radio, forKey: .radio)
	}
}
