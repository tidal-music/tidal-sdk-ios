import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - PromptColors

/// Primary and Secondary color to visually render the pick
public struct PromptColors: Codable, Hashable {
	/// Primary color to visually render the pick
	public var primary: String
	/// Secondary color to visually render the pick
	public var secondary: String

	public init(primary: String, secondary: String) {
		self.primary = primary
		self.secondary = secondary
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case primary
		case secondary
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(primary, forKey: .primary)
		try container.encode(secondary, forKey: .secondary)
	}
}
