//
// PlaylistUpdateOperationPayloadData.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct PlaylistUpdateOperationPayloadData: Codable, Hashable {

    public enum ModelType: String, Codable, CaseIterable {
        case playlists = "playlists"
    }
    public var id: String
    public var type: ModelType
    public var attributes: PlaylistUpdateOperationPayloadDataAttributes

    public init(id: String, type: ModelType, attributes: PlaylistUpdateOperationPayloadDataAttributes) {
        self.id = id
        self.type = type
        self.attributes = attributes
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case type
        case attributes
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(attributes, forKey: .attributes)
    }
}


@available(iOS 13, tvOS 13, watchOS 6, macOS 10.15, *)
extension PlaylistUpdateOperationPayloadData: Identifiable {}

