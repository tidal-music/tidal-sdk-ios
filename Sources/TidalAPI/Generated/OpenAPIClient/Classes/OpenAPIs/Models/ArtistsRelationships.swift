import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ArtistsRelationships

public struct ArtistsRelationships: Codable, Hashable {
	public var similarArtists: MultiDataRelationshipDoc
	public var albums: MultiDataRelationshipDoc
	public var videos: MultiDataRelationshipDoc
	public var trackProviders: ArtistsTrackProvidersMultiDataRelationshipDocument
	public var tracks: MultiDataRelationshipDoc
	public var radio: MultiDataRelationshipDoc

	public init(
		similarArtists: MultiDataRelationshipDoc,
		albums: MultiDataRelationshipDoc,
		videos: MultiDataRelationshipDoc,
		trackProviders: ArtistsTrackProvidersMultiDataRelationshipDocument,
		tracks: MultiDataRelationshipDoc,
		radio: MultiDataRelationshipDoc
	) {
		self.similarArtists = similarArtists
		self.albums = albums
		self.videos = videos
		self.trackProviders = trackProviders
		self.tracks = tracks
		self.radio = radio
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case similarArtists
		case albums
		case videos
		case trackProviders
		case tracks
		case radio
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(similarArtists, forKey: .similarArtists)
		try container.encode(albums, forKey: .albums)
		try container.encode(videos, forKey: .videos)
		try container.encode(trackProviders, forKey: .trackProviders)
		try container.encode(tracks, forKey: .tracks)
		try container.encode(radio, forKey: .radio)
	}
}
