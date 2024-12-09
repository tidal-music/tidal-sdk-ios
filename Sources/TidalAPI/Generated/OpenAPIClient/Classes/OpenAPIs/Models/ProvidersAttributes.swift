import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ProvidersAttributes

public struct ProvidersAttributes: Codable, Hashable {
	/// Provider name. Conditionally visible.
	public var name: String

	public init(name: String) {
		self.name = name
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case name
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
	}
}
