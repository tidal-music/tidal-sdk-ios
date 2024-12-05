import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UpdatePickRelationshipBodyData

public struct UpdatePickRelationshipBodyData: Codable, Hashable {
	public var type: String?
	public var id: String?

	public init(type: String? = nil, id: String? = nil) {
		self.type = type
		self.id = id
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case type
		case id
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(type, forKey: .type)
		try container.encodeIfPresent(id, forKey: .id)
	}
}
