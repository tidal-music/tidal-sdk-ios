//
// PlaylistCreateOperationPayloadData.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct PlaylistCreateOperationPayloadData: Codable, Hashable {

    public enum ModelType: String, Codable, CaseIterable {
        case playlists = "playlists"
    }
    public var type: ModelType
    public var attributes: PlaylistCreateOperationPayloadDataAttributes

    public init(
        type: ModelType,
        attributes: PlaylistCreateOperationPayloadDataAttributes
    ) {
        self.type = type
        self.attributes = attributes
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case type
        case attributes
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(attributes, forKey: .attributes)
    }
}


