import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - CatalogueItemExternalLink

public struct CatalogueItemExternalLink: Codable, Hashable {
	/// link to something that is related to a resource
	public var href: String
	public var meta: ExternalLinkMeta

	public init(href: String, meta: ExternalLinkMeta) {
		self.href = href
		self.meta = meta
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case href
		case meta
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(href, forKey: .href)
		try container.encode(meta, forKey: .meta)
	}
}
