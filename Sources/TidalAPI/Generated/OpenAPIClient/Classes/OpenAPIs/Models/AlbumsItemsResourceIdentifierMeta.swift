import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - AlbumsItemsResourceIdentifierMeta

public struct AlbumsItemsResourceIdentifierMeta: Codable, Hashable {
	/// volume number
	public var volumeNumber: Int
	/// track number
	public var trackNumber: Int

	public init(volumeNumber: Int, trackNumber: Int) {
		self.volumeNumber = volumeNumber
		self.trackNumber = trackNumber
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case volumeNumber
		case trackNumber
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(volumeNumber, forKey: .volumeNumber)
		try container.encode(trackNumber, forKey: .trackNumber)
	}
}
