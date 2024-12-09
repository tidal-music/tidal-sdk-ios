import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - VideosMultiDataDocument

public struct VideosMultiDataDocument: Codable, Hashable {
	public var data: [VideosResource]?
	public var links: Links?
	public var included: [VideosSingleDataDocumentIncludedInner]?

	public init(data: [VideosResource]? = nil, links: Links? = nil, included: [VideosSingleDataDocumentIncludedInner]? = nil) {
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
