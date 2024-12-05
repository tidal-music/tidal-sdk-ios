import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - CatalogueItemImageLink

public struct CatalogueItemImageLink: Codable, Hashable {
	/// link to an image
	public var href: String
	public var meta: ImageLinkMeta

	public init(href: String, meta: ImageLinkMeta) {
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
