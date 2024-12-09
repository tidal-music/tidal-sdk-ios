import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UpdateUserProfileBodyData

public struct UpdateUserProfileBodyData: Codable, Hashable {
	public var attributes: UpdateUserProfileBodyDataAttributes?

	public init(attributes: UpdateUserProfileBodyDataAttributes? = nil) {
		self.attributes = attributes
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case attributes
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(attributes, forKey: .attributes)
	}
}
