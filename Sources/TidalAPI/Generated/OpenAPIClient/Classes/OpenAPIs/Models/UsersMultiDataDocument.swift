import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UsersMultiDataDocument

public struct UsersMultiDataDocument: Codable, Hashable {
	public var data: [UsersResource]?
	public var links: Links?
	public var included: [UsersSingleDataDocumentIncludedInner]?

	public init(data: [UsersResource]? = nil, links: Links? = nil, included: [UsersSingleDataDocumentIncludedInner]? = nil) {
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
