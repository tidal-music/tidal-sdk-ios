import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ArtistsTrackProvidersResourceIdentifierMeta

public struct ArtistsTrackProvidersResourceIdentifierMeta: Codable, Hashable {
	/// total number of tracks released together with the provider
	public var numberOfTracks: Int64

	public init(numberOfTracks: Int64) {
		self.numberOfTracks = numberOfTracks
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case numberOfTracks
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(numberOfTracks, forKey: .numberOfTracks)
	}
}
