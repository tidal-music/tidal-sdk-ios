//
// UserCollectionPlaylistsRelationshipRemoveOperationPayloadData.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct UserCollectionPlaylistsRelationshipRemoveOperationPayloadData: Codable, Hashable {

    public enum ModelType: String, Codable, CaseIterable {
        case playlists = "playlists"
    }
    public var id: String
    public var type: ModelType

    public init(id: String, type: ModelType) {
        self.id = id
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case type
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }
}


@available(iOS 13, tvOS 13, watchOS 6, macOS 10.15, *)
extension UserCollectionPlaylistsRelationshipRemoveOperationPayloadData: Identifiable {}
