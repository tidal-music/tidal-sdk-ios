//
// TrackStatisticsResource.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct TrackStatisticsResource: Codable, Hashable {

    public var attributes: TrackStatisticsAttributes?
    /** resource unique identifier */
    public var id: String
    public var relationships: TrackStatisticsRelationships?
    /** resource unique type */
    public var type: String

    public init(
        attributes: TrackStatisticsAttributes? = nil,
        id: String,
        relationships: TrackStatisticsRelationships? = nil,
        type: String
    ) {
        self.attributes = attributes
        self.id = id
        self.relationships = relationships
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attributes
        case id
        case relationships
        case type
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(attributes, forKey: .attributes)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(relationships, forKey: .relationships)
        try container.encode(type, forKey: .type)
    }
}


@available(iOS 13, tvOS 13, watchOS 6, macOS 10.15, *)
extension TrackStatisticsResource: Identifiable {}

