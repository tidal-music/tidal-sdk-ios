import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - TracksResource

public struct TracksResource: Codable, Hashable {
	public var attributes: TracksAttributes?
	public var relationships: TracksRelationships?
	public var links: Links?
	/// resource unique identifier
	public var id: String
	/// resource unique type
	public var type: String

	public init(
		attributes: TracksAttributes? = nil,
		relationships: TracksRelationships? = nil,
		links: Links? = nil,
		id: String,
		type: String
	) {
		self.attributes = attributes
		self.relationships = relationships
		self.links = links
		self.id = id
		self.type = type
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case attributes
		case relationships
		case links
		case id
		case type
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(attributes, forKey: .attributes)
		try container.encodeIfPresent(relationships, forKey: .relationships)
		try container.encodeIfPresent(links, forKey: .links)
		try container.encode(id, forKey: .id)
		try container.encode(type, forKey: .type)
	}
}
