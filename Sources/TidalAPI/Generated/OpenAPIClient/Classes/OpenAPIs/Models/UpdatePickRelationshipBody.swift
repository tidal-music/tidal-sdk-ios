import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UpdatePickRelationshipBody

public struct UpdatePickRelationshipBody: Codable, Hashable {
	public var data: UpdatePickRelationshipBodyData?

	public init(data: UpdatePickRelationshipBodyData? = nil) {
		self.data = data
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case data
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(data, forKey: .data)
	}
}
