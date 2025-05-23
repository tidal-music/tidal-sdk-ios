//
// ImageLink.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

@available(*, deprecated, message: "This schema is deprecated.")
public struct ImageLink: Codable, Hashable {

    public var href: String
    public var meta: ImageLinkMeta

    public init(href: String, meta: ImageLinkMeta) {
        self.href = href
        self.meta = meta
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case href
        case meta
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(href, forKey: .href)
        try container.encode(meta, forKey: .meta)
    }
}


