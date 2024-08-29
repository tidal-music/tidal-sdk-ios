//
// ImageLinkMeta.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** metadata about an image */
public struct ImageLinkMeta: Codable, Hashable {

    /** image width (in pixels) */
    public var width: Int
    /** image height (in pixels) */
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
