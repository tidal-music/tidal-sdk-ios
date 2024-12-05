import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UpdateUserProfileBodyDataAttributes

public struct UpdateUserProfileBodyDataAttributes: Codable, Hashable {
	public var handle: String?
	public var profileName: String?
	public var externalLinks: [UserPublicProfilesExternalLink]?

	public init(handle: String? = nil, profileName: String? = nil, externalLinks: [UserPublicProfilesExternalLink]? = nil) {
		self.handle = handle
		self.profileName = profileName
		self.externalLinks = externalLinks
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case handle
		case profileName
		case externalLinks
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(handle, forKey: .handle)
		try container.encodeIfPresent(profileName, forKey: .profileName)
		try container.encodeIfPresent(externalLinks, forKey: .externalLinks)
	}
}
