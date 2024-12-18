import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ArtistRole

public struct ArtistRole: Codable, Hashable {
	public var id: String?
	public var name: String?

	public init(id: String? = nil, name: String? = nil) {
		self.id = id
		self.name = name
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case id
		case name
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(id, forKey: .id)
		try container.encodeIfPresent(name, forKey: .name)
	}
}
