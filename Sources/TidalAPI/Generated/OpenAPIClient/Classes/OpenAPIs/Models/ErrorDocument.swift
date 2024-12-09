import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ErrorDocument

/// JSON:API error document object
public struct ErrorDocument: Codable, Hashable {
	/// array of error objects
	public var errors: [ErrorObject]?
	public var links: Links?

	public init(errors: [ErrorObject]? = nil, links: Links? = nil) {
		self.errors = errors
		self.links = links
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case errors
		case links
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(errors, forKey: .errors)
		try container.encodeIfPresent(links, forKey: .links)
	}
}
