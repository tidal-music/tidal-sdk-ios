//
// UserReportCreateOperationPayloadData.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct UserReportCreateOperationPayloadData: Codable, Hashable {

    public enum ModelType: String, Codable, CaseIterable {
        case userreports = "userReports"
    }
    public var attributes: UserReportCreateOperationPayloadDataAttributes
    public var relationships: UserReportsCreateOperationPayloadDataRelationships
    public var type: ModelType

    public init(
        attributes: UserReportCreateOperationPayloadDataAttributes,
        relationships: UserReportsCreateOperationPayloadDataRelationships,
        type: ModelType
    ) {
        self.attributes = attributes
        self.relationships = relationships
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attributes
        case relationships
        case type
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(attributes, forKey: .attributes)
        try container.encode(relationships, forKey: .relationships)
        try container.encode(type, forKey: .type)
    }
}


