import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ArtistsTrackProvidersMultiDataRelationshipDocument

public struct ArtistsTrackProvidersMultiDataRelationshipDocument: Codable, Hashable {
	public var data: [ArtistsTrackProvidersResourceIdentifier]?
	public var links: Links?

	public init(data: [ArtistsTrackProvidersResourceIdentifier]? = nil, links: Links? = nil) {
		self.data = data
		self.links = links
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case data
		case links
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(data, forKey: .data)
		try container.encodeIfPresent(links, forKey: .links)
	}
}
