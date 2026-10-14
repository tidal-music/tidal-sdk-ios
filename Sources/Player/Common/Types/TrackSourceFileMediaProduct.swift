import Foundation

// MARK: - TrackSourceFileMediaProduct

/// A specific source file (version) of a track, played from `GET /trackSourceFileManifests/{sourceFileId}`.
///
/// Reported as ``ProductType/TRACK_SOURCE_FILE`` with `productId` set to `trackId` and the source file id alongside.
/// Online only, and never claims streaming privileges.
///
/// - Important: `trackId` must be the track the source file belongs to; it is what plays are reported against.
public final class TrackSourceFileMediaProduct: MediaProduct {
	public let sourceFileId: UUID

	/// The id of the track the source file belongs to. Same value as `productId`.
	public var trackId: String {
		productId
	}

	public init(
		sourceFileId: UUID,
		trackId: String,
		referenceId: String? = nil,
		progressSource: Source? = nil,
		playLogSource: Source? = nil,
		extras: Extras? = nil
	) {
		self.sourceFileId = sourceFileId
		super.init(
			productType: .TRACK_SOURCE_FILE,
			productId: trackId,
			referenceId: referenceId,
			progressSource: progressSource,
			playLogSource: playLogSource,
			extras: extras
		)
	}

	// MARK: - Codable

	private enum CodingKeys: String, CodingKey {
		case sourceFileId
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		sourceFileId = try container.decode(UUID.self, forKey: .sourceFileId)
		try super.init(from: decoder)
	}

	override public func encode(to encoder: Encoder) throws {
		try super.encode(to: encoder)
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(sourceFileId, forKey: .sourceFileId)
	}
}

extension MediaProduct {
	/// The source file id as sent to the backend and reported in events (lowercase UUID); nil for other products.
	var sourceFileIdentifier: String? {
		(self as? TrackSourceFileMediaProduct)?.sourceFileId.uuidString.lowercased()
	}
}
