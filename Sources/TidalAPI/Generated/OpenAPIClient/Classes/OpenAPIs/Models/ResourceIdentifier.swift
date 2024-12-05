import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ResourceIdentifier

/// Resource identifier JSON:API object
public struct ResourceIdentifier: Codable, Hashable {
	/// resource unique identifier
	public var id: String
	/// resource unique type
	public var type: String

	public init(id: String, type: String) {
		self.id = id
		self.type = type
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case id
		case type
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(type, forKey: .type)
	}
}
