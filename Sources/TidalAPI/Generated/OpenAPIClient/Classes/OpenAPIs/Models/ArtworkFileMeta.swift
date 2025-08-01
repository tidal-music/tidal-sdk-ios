//
// ArtworkFileMeta.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Metadata about an artwork file */
public struct ArtworkFileMeta: Codable, Hashable {

    /** Height (in pixels) */
    public var height: Int
    /** Width (in pixels) */
    public var width: Int

    public init(
        height: Int,
        width: Int
    ) {
        self.height = height
        self.width = width
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case height
        case width
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
    }
}


