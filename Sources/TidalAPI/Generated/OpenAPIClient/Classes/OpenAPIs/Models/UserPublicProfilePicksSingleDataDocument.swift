import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserPublicProfilePicksSingleDataDocument

public struct UserPublicProfilePicksSingleDataDocument: Codable, Hashable {
	public var data: UserPublicProfilePicksResource?
	public var links: Links?
	public var included: [UserPublicProfilePicksSingleDataDocumentIncludedInner]?

	public init(
		data: UserPublicProfilePicksResource? = nil,
		links: Links? = nil,
		included: [UserPublicProfilePicksSingleDataDocumentIncludedInner]? = nil
	) {
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
