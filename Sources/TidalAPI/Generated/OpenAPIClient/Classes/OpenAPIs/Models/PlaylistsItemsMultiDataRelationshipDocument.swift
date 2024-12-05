import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - PlaylistsItemsMultiDataRelationshipDocument

public struct PlaylistsItemsMultiDataRelationshipDocument: Codable, Hashable {
	public var data: [PlaylistsItemsResourceIdentifier]?
	public var links: Links?

	public init(data: [PlaylistsItemsResourceIdentifier]? = nil, links: Links? = nil) {
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
