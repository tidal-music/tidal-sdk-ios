//
// PlaylistItemsRelationshipReorderOperationPayload.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct PlaylistItemsRelationshipReorderOperationPayload: Codable, Hashable {

    public static let dataRule = ArrayRule(minItems: 1, maxItems: 20, uniqueItems: false)
    public var data: [PlaylistItemsRelationshipReorderOperationPayloadData]
    public var meta: PlaylistItemsRelationshipReorderOperationPayloadMeta?

    public init(data: [PlaylistItemsRelationshipReorderOperationPayloadData], meta: PlaylistItemsRelationshipReorderOperationPayloadMeta? = nil) {
        self.data = data
        self.meta = meta
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case data
        case meta
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encodeIfPresent(meta, forKey: .meta)
    }
}


