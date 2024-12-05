import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - SearchresultsAttributes

public struct SearchresultsAttributes: Codable, Hashable {
	/// search request unique tracking number
	public var trackingId: String
	/// 'did you mean' prompt
	public var didYouMean: String?

	public init(trackingId: String, didYouMean: String? = nil) {
		self.trackingId = trackingId
		self.didYouMean = didYouMean
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case trackingId
		case didYouMean
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(trackingId, forKey: .trackingId)
		try container.encodeIfPresent(didYouMean, forKey: .didYouMean)
	}
}
