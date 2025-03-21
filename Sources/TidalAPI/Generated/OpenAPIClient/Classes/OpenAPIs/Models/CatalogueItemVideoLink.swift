import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - CatalogueItemVideoLink

public struct CatalogueItemVideoLink: Codable, Hashable {
	/// link to a video
	public var href: String
	public var meta: VideoLinkMeta

	public init(href: String, meta: VideoLinkMeta) {
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
