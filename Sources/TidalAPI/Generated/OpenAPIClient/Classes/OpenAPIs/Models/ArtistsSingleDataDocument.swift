import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ArtistsSingleDataDocument

public struct ArtistsSingleDataDocument: Codable, Hashable {
	public var data: ArtistsResource?
	public var links: Links?
	public var included: [ArtistsSingleDataDocumentIncludedInner]?

	public init(data: ArtistsResource? = nil, links: Links? = nil, included: [ArtistsSingleDataDocumentIncludedInner]? = nil) {
		self.data = data
		self.links = links
		self.included = included
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case data
		case links
		case included
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(data, forKey: .data)
		try container.encodeIfPresent(links, forKey: .links)
		try container.encodeIfPresent(included, forKey: .included)
	}
}
