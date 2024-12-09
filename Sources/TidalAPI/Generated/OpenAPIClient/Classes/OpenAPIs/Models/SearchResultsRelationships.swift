import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - SearchresultsRelationships

public struct SearchresultsRelationships: Codable, Hashable {
	public var albums: MultiDataRelationshipDoc
	public var artists: MultiDataRelationshipDoc
	public var playlists: MultiDataRelationshipDoc
	public var videos: MultiDataRelationshipDoc
	public var topHits: MultiDataRelationshipDoc
	public var tracks: MultiDataRelationshipDoc

	public init(
		albums: MultiDataRelationshipDoc,
		artists: MultiDataRelationshipDoc,
		playlists: MultiDataRelationshipDoc,
		videos: MultiDataRelationshipDoc,
		topHits: MultiDataRelationshipDoc,
		tracks: MultiDataRelationshipDoc
	) {
		self.albums = albums
		self.artists = artists
		self.playlists = playlists
		self.videos = videos
		self.topHits = topHits
		self.tracks = tracks
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case albums
		case artists
		case playlists
		case videos
		case topHits
		case tracks
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(albums, forKey: .albums)
		try container.encode(artists, forKey: .artists)
		try container.encode(playlists, forKey: .playlists)
		try container.encode(videos, forKey: .videos)
		try container.encode(topHits, forKey: .topHits)
		try container.encode(tracks, forKey: .tracks)
	}
}
