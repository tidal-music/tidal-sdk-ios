import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - TracksSingleDataDocument

public struct TracksSingleDataDocument: Codable, Hashable {
	public var data: TracksResource?
	public var links: Links?
	public var included: [TracksSingleDataDocumentIncludedInner]?

	public init(data: TracksResource? = nil, links: Links? = nil, included: [TracksSingleDataDocumentIncludedInner]? = nil) {
		self.data = data
		self.links = links
		self.included = included
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case data
		case links
		case included
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(data, forKey: .data)
		try container.encodeIfPresent(links, forKey: .links)
		try container.encodeIfPresent(included, forKey: .included)
	}
}
