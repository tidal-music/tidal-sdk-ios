import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - AlbumsItemsMultiDataRelationshipDocument

public struct AlbumsItemsMultiDataRelationshipDocument: Codable, Hashable {
	public var data: [AlbumsItemsResourceIdentifier]?
	public var links: Links?

	public init(data: [AlbumsItemsResourceIdentifier]? = nil, links: Links? = nil) {
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
