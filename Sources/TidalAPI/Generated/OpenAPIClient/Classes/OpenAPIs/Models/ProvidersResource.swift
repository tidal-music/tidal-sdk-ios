import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ProvidersResource

public struct ProvidersResource: Codable, Hashable {
	public var attributes: ProvidersAttributes?
	public var links: Links?
	/// resource unique identifier
	public var id: String
	/// resource unique type
	public var type: String

	public init(attributes: ProvidersAttributes? = nil, links: Links? = nil, id: String, type: String) {
		self.attributes = attributes
		self.links = links
		self.id = id
		self.type = type
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case attributes
		case links
		case id
		case type
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(attributes, forKey: .attributes)
		try container.encodeIfPresent(links, forKey: .links)
		try container.encode(id, forKey: .id)
		try container.encode(type, forKey: .type)
	}
}
