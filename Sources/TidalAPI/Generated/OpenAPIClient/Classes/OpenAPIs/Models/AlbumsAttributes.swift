import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - AlbumsAttributes

public struct AlbumsAttributes: Codable, Hashable {
	public enum Availability: String, Codable, CaseIterable {
		case stream = "STREAM"
		case dj = "DJ"
		case stem = "STEM"
	}

	public enum ModelType: String, Codable, CaseIterable {
		case album = "ALBUM"
		case ep = "EP"
		case single = "SINGLE"
	}

	/// Original title
	public var title: String
	/// Barcode id (EAN-13 or UPC-A)
	public var barcodeId: String
	/// Number of volumes
	public var numberOfVolumes: Int
	/// Number of album items
	public var numberOfItems: Int
	/// Duration (ISO-8601)
	public var duration: String
	/// Indicates whether an album consist of any explicit content
	public var explicit: Bool
	/// Release date (ISO-8601)
	public var releaseDate: Date?
	/// Copyright information
	public var copyright: String?
	/// Album popularity (ranged in 0.00 ... 1.00). Conditionally visible
	public var popularity: Double
	/// Defines an album availability e.g. for streaming, DJs, stems
	public var availability: [Availability]?
	public var mediaTags: [String]
	/// Represents available links to, and metadata about, an album cover images
	public var imageLinks: [CatalogueItemImageLink]?
	/// Represents available links to, and metadata about, an album cover videos
	public var videoLinks: [CatalogueItemVideoLink]?
	/// Represents available links to something that is related to an album resource, but external to the TIDAL API
	public var externalLinks: [CatalogueItemExternalLink]?
	/// Album type, e.g. single, regular album, or extended play
	public var type: ModelType

	public init(
		title: String,
		barcodeId: String,
		numberOfVolumes: Int,
		numberOfItems: Int,
		duration: String,
		explicit: Bool,
		releaseDate: Date? = nil,
		copyright: String? = nil,
		popularity: Double,
		availability: [Availability]? = nil,
		mediaTags: [String],
		imageLinks: [CatalogueItemImageLink]? = nil,
		videoLinks: [CatalogueItemVideoLink]? = nil,
		externalLinks: [CatalogueItemExternalLink]? = nil,
		type: ModelType
	) {
		self.title = title
		self.barcodeId = barcodeId
		self.numberOfVolumes = numberOfVolumes
		self.numberOfItems = numberOfItems
		self.duration = duration
		self.explicit = explicit
		self.releaseDate = releaseDate
		self.copyright = copyright
		self.popularity = popularity
		self.availability = availability
		self.mediaTags = mediaTags
		self.imageLinks = imageLinks
		self.videoLinks = videoLinks
		self.externalLinks = externalLinks
		self.type = type
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case title
		case barcodeId
		case numberOfVolumes
		case numberOfItems
		case duration
		case explicit
		case releaseDate
		case copyright
		case popularity
		case availability
		case mediaTags
		case imageLinks
		case videoLinks
		case externalLinks
		case type
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(title, forKey: .title)
		try container.encode(barcodeId, forKey: .barcodeId)
		try container.encode(numberOfVolumes, forKey: .numberOfVolumes)
		try container.encode(numberOfItems, forKey: .numberOfItems)
		try container.encode(duration, forKey: .duration)
		try container.encode(explicit, forKey: .explicit)
		try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
		try container.encodeIfPresent(copyright, forKey: .copyright)
		try container.encode(popularity, forKey: .popularity)
		try container.encodeIfPresent(availability, forKey: .availability)
		try container.encode(mediaTags, forKey: .mediaTags)
		try container.encodeIfPresent(imageLinks, forKey: .imageLinks)
		try container.encodeIfPresent(videoLinks, forKey: .videoLinks)
		try container.encodeIfPresent(externalLinks, forKey: .externalLinks)
		try container.encode(type, forKey: .type)
	}
}
