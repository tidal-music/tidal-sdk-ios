import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ArtistsAttributes

public struct ArtistsAttributes: Codable, Hashable {
	/// Artist name
	public var name: String
	/// Artist popularity (ranged in 0.00 ... 1.00). Conditionally visible
	public var popularity: Double
	/// Represents available links to, and metadata about, an artist images
	public var imageLinks: [CatalogueItemImageLink]?
	/// Represents available links to something that is related to an artist resource, but external to the TIDAL API
	public var externalLinks: [CatalogueItemExternalLink]?
	/// Artist roles
	public var roles: [ArtistRole]?

	public init(
		name: String,
		popularity: Double,
		imageLinks: [CatalogueItemImageLink]? = nil,
		externalLinks: [CatalogueItemExternalLink]? = nil,
		roles: [ArtistRole]? = nil
	) {
		self.name = name
		self.popularity = popularity
		self.imageLinks = imageLinks
		self.externalLinks = externalLinks
		self.roles = roles
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case name
		case popularity
		case imageLinks
		case externalLinks
		case roles
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
		try container.encode(popularity, forKey: .popularity)
		try container.encodeIfPresent(imageLinks, forKey: .imageLinks)
		try container.encodeIfPresent(externalLinks, forKey: .externalLinks)
		try container.encodeIfPresent(roles, forKey: .roles)
	}
}
