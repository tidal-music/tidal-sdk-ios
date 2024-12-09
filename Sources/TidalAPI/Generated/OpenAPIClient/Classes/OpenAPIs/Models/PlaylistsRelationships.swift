import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - PlaylistsRelationships

public struct PlaylistsRelationships: Codable, Hashable {
	public var owners: MultiDataRelationshipDoc
	public var items: PlaylistsItemsMultiDataRelationshipDocument

	public init(owners: MultiDataRelationshipDoc, items: PlaylistsItemsMultiDataRelationshipDocument) {
		self.owners = owners
		self.items = items
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case owners
		case items
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(owners, forKey: .owners)
		try container.encode(items, forKey: .items)
	}
}
