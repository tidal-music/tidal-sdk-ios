import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserPublicProfilesMultiDataRelationshipDocument

public struct UserPublicProfilesMultiDataRelationshipDocument: Codable, Hashable {
	public var data: [ResourceIdentifier]?
	public var links: Links?
	public var included: [UserPublicProfilesMultiDataRelationshipDocumentIncludedInner]?

	public init(
		data: [ResourceIdentifier]? = nil,
		links: Links? = nil,
		included: [UserPublicProfilesMultiDataRelationshipDocumentIncludedInner]? = nil
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
