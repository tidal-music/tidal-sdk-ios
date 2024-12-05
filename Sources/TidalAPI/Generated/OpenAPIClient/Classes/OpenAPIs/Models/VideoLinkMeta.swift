import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - VideoLinkMeta

/// metadata about a video
public struct VideoLinkMeta: Codable, Hashable {
	/// video width (in pixels)
	public var width: Int
	/// video height (in pixels)
	public var height: Int

	public init(width: Int, height: Int) {
		self.width = width
		self.height = height
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case width
		case height
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(width, forKey: .width)
		try container.encode(height, forKey: .height)
	}
}
