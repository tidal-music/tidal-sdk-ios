//
// UserCollectionAlbumsRelationshipRemoveOperationPayloadDataMeta.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct UserCollectionAlbumsRelationshipRemoveOperationPayloadDataMeta: Codable, Hashable {

    public var itemId: String

    public init(itemId: String) {
        self.itemId = itemId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case itemId
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(itemId, forKey: .itemId)
    }
}

