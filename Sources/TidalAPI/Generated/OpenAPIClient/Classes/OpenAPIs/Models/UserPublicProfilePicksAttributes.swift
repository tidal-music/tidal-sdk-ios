import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserPublicProfilePicksAttributes

public struct UserPublicProfilePicksAttributes: Codable, Hashable {
	public enum SupportedContentType: String, Codable, CaseIterable {
		case tracks = "TRACKS"
		case videos = "VIDEOS"
		case albums = "ALBUMS"
		case artists = "ARTISTS"
		case providers = "PROVIDERS"
	}

	/// Pick title
	public var title: String
	/// Description of pick
	public var description: String
	/// CatalogueResourceType for supported item for the pick
	public var supportedContentType: SupportedContentType
	public var colors: PromptColors
	/// Date of last modification of the pick (ISO 8601)
	public var lastModifiedAt: Date?

	public init(
		title: String,
		description: String,
		supportedContentType: SupportedContentType,
		colors: PromptColors,
		lastModifiedAt: Date? = nil
	) {
		self.title = title
		self.description = description
		self.supportedContentType = supportedContentType
		self.colors = colors
		self.lastModifiedAt = lastModifiedAt
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case title
		case description
		case supportedContentType
		case colors
		case lastModifiedAt
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(title, forKey: .title)
		try container.encode(description, forKey: .description)
		try container.encode(supportedContentType, forKey: .supportedContentType)
		try container.encode(colors, forKey: .colors)
		try container.encodeIfPresent(lastModifiedAt, forKey: .lastModifiedAt)
	}
}
