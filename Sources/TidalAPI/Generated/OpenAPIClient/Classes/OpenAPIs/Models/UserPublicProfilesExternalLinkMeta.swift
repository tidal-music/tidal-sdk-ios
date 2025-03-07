import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserPublicProfilesExternalLinkMeta

/// metadata about an external link
public struct UserPublicProfilesExternalLinkMeta: Codable, Hashable {
	public enum ModelType: String, Codable, CaseIterable {
		case tidalSharing = "TIDAL_SHARING"
		case tidalAutoplayAndroid = "TIDAL_AUTOPLAY_ANDROID"
		case tidalAutoplayIos = "TIDAL_AUTOPLAY_IOS"
		case tidalAutoplayWeb = "TIDAL_AUTOPLAY_WEB"
		case twitter = "TWITTER"
		case facebook = "FACEBOOK"
		case instagram = "INSTAGRAM"
		case tiktok = "TIKTOK"
		case snapchat = "SNAPCHAT"
		case homepage = "HOMEPAGE"
	}

	/// external link type
	public var type: ModelType
	/// external link handle
	public var handle: String

	public init(type: ModelType, handle: String) {
		self.type = type
		self.handle = handle
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case type
		case handle
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(type, forKey: .type)
		try container.encode(handle, forKey: .handle)
	}
}
