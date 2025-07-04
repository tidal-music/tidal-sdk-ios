//
// ExternalLinkMeta.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** metadata about an external link */
public struct ExternalLinkMeta: Codable, Hashable {

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
        case cashappContributions = "CASHAPP_CONTRIBUTIONS"
    }
    public var type: ModelType

    public init(
        type: ModelType
    ) {
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case type
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
    }
}


