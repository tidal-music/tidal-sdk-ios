import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - VideosAttributes

public struct VideosAttributes: Codable, Hashable {
	public enum Availability: String, Codable, CaseIterable {
		case stream = "STREAM"
		case dj = "DJ"
		case stem = "STEM"
	}

	/// Album item's title
	public var title: String
	/// Version of the album's item; complements title
	public var version: String?
	/// ISRC code
	public var isrc: String
	/// Duration expressed in accordance with ISO 8601
	public var duration: String
	/// Copyright information
	public var copyright: String?
	/// Release date (ISO-8601)
	public var releaseDate: Date?
	/// Indicates whether a catalog item consist of any explicit content
	public var explicit: Bool
	/// Track or video popularity (ranged in 0.00 ... 1.00). Conditionally visible
	public var popularity: Double
	/// Defines a catalog item availability e.g. for streaming, DJs, stems
	public var availability: [Availability]?
	/// Represents available links to, and metadata about, an album item images
	public var imageLinks: [CatalogueItemImageLink]?
	/// Represents available links to something that is related to a catalog item, but external to the TIDAL API
	public var externalLinks: [CatalogueItemExternalLink]?

	public init(
		title: String,
		version: String? = nil,
		isrc: String,
		duration: String,
		copyright: String? = nil,
		releaseDate: Date? = nil,
		explicit: Bool,
		popularity: Double,
		availability: [Availability]? = nil,
		imageLinks: [CatalogueItemImageLink]? = nil,
		externalLinks: [CatalogueItemExternalLink]? = nil
	) {
		self.title = title
		self.version = version
		self.isrc = isrc
		self.duration = duration
		self.copyright = copyright
		self.releaseDate = releaseDate
		self.explicit = explicit
		self.popularity = popularity
		self.availability = availability
		self.imageLinks = imageLinks
		self.externalLinks = externalLinks
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case title
		case version
		case isrc
		case duration
		case copyright
		case releaseDate
		case explicit
		case popularity
		case availability
		case imageLinks
		case externalLinks
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(title, forKey: .title)
		try container.encodeIfPresent(version, forKey: .version)
		try container.encode(isrc, forKey: .isrc)
		try container.encode(duration, forKey: .duration)
		try container.encodeIfPresent(copyright, forKey: .copyright)
		try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
		try container.encode(explicit, forKey: .explicit)
		try container.encode(popularity, forKey: .popularity)
		try container.encodeIfPresent(availability, forKey: .availability)
		try container.encodeIfPresent(imageLinks, forKey: .imageLinks)
		try container.encodeIfPresent(externalLinks, forKey: .externalLinks)
	}
}
