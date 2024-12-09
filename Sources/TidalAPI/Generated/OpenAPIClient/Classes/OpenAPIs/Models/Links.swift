import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - Links

/// Links JSON:API object
public struct Links: Codable, Hashable {
	/// the link that generated the current response document
	public var _self: String
	/// the next page of data (pagination)
	public var next: String?

	public init(_self: String, next: String? = nil) {
		self._self = _self
		self.next = next
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case _self = "self"
		case next
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(_self, forKey: ._self)
		try container.encodeIfPresent(next, forKey: .next)
	}
}
