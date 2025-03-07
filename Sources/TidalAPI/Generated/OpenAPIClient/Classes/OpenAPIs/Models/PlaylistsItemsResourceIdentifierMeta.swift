import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - PlaylistsItemsResourceIdentifierMeta

public struct PlaylistsItemsResourceIdentifierMeta: Codable, Hashable {
	/// Unique identifier of the item in a playlist
	public var itemId: String?
	/// When the item was added to the playlist
	public var addedAt: Date?

	public init(itemId: String? = nil, addedAt: Date? = nil) {
		self.itemId = itemId
		self.addedAt = addedAt
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case itemId
		case addedAt
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(itemId, forKey: .itemId)
		try container.encodeIfPresent(addedAt, forKey: .addedAt)
	}
}
