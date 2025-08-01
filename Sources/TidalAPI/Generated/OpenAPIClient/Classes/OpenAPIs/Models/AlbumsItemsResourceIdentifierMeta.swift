//
// AlbumsItemsResourceIdentifierMeta.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct AlbumsItemsResourceIdentifierMeta: Codable, Hashable {

    /** track number */
    public var trackNumber: Int
    /** volume number */
    public var volumeNumber: Int

    public init(
        trackNumber: Int,
        volumeNumber: Int
    ) {
        self.trackNumber = trackNumber
        self.volumeNumber = volumeNumber
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case trackNumber
        case volumeNumber
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(trackNumber, forKey: .trackNumber)
        try container.encode(volumeNumber, forKey: .volumeNumber)
    }
}


