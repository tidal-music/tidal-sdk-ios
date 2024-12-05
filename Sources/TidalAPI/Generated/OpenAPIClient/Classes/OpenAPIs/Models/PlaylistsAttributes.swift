import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - PlaylistsAttributes

public struct PlaylistsAttributes: Codable, Hashable {
	/// Playlist name
	public var name: String
	/// Playlist description
	public var description: String?
	/// Indicates if the playlist has a duration and set number of tracks
	public var bounded: Bool
	/// Duration of the playlist expressed in accordance with ISO 8601
	public var duration: String?
	/// Number of items in the playlist
	public var numberOfItems: Int?
	/// Sharing links to the playlist
	public var externalLinks: [PlaylistsExternalLink]
	/// Datetime of playlist creation (ISO 8601)
	public var createdAt: Date
	/// Datetime of last modification of the playlist (ISO 8601)
	public var lastModifiedAt: Date
	/// Privacy setting of the playlist
	public var privacy: String
	/// The type of the playlist
	public var playlistType: String
	/// Images associated with the playlist
	public var imageLinks: [PlaylistsImageLink]

	public init(
		name: String,
		description: String? = nil,
		bounded: Bool,
		duration: String? = nil,
		numberOfItems: Int? = nil,
		externalLinks: [PlaylistsExternalLink],
		createdAt: Date,
		lastModifiedAt: Date,
		privacy: String,
		playlistType: String,
		imageLinks: [PlaylistsImageLink]
	) {
		self.name = name
		self.description = description
		self.bounded = bounded
		self.duration = duration
		self.numberOfItems = numberOfItems
		self.externalLinks = externalLinks
		self.createdAt = createdAt
		self.lastModifiedAt = lastModifiedAt
		self.privacy = privacy
		self.playlistType = playlistType
		self.imageLinks = imageLinks
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case name
		case description
		case bounded
		case duration
		case numberOfItems
		case externalLinks
		case createdAt
		case lastModifiedAt
		case privacy
		case playlistType
		case imageLinks
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
		try container.encodeIfPresent(description, forKey: .description)
		try container.encode(bounded, forKey: .bounded)
		try container.encodeIfPresent(duration, forKey: .duration)
		try container.encodeIfPresent(numberOfItems, forKey: .numberOfItems)
		try container.encode(externalLinks, forKey: .externalLinks)
		try container.encode(createdAt, forKey: .createdAt)
		try container.encode(lastModifiedAt, forKey: .lastModifiedAt)
		try container.encode(privacy, forKey: .privacy)
		try container.encode(playlistType, forKey: .playlistType)
		try container.encode(imageLinks, forKey: .imageLinks)
	}
}
