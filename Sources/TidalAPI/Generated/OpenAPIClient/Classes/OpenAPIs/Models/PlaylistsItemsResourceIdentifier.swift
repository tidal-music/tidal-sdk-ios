import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - PlaylistsItemsResourceIdentifier

/// Resource identifier JSON:API object
public struct PlaylistsItemsResourceIdentifier: Codable, Hashable {
	/// resource unique identifier
	public var id: String
	/// resource unique type
	public var type: String
	public var meta: PlaylistsItemsResourceIdentifierMeta?

	public init(id: String, type: String, meta: PlaylistsItemsResourceIdentifierMeta? = nil) {
		self.id = id
		self.type = type
		self.meta = meta
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case id
		case type
		case meta
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(type, forKey: .type)
		try container.encodeIfPresent(meta, forKey: .meta)
	}
}
