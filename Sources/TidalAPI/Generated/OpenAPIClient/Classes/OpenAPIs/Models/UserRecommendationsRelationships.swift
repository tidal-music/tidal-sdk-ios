//
// UserRecommendationsRelationships.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct UserRecommendationsRelationships: Codable, Hashable {

    public var discoveryMixes: MultiDataRelationshipDoc
    public var newArrivalMixes: MultiDataRelationshipDoc
    public var myMixes: MultiDataRelationshipDoc

    public init(discoveryMixes: MultiDataRelationshipDoc, newArrivalMixes: MultiDataRelationshipDoc, myMixes: MultiDataRelationshipDoc) {
        self.discoveryMixes = discoveryMixes
        self.newArrivalMixes = newArrivalMixes
        self.myMixes = myMixes
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case discoveryMixes
        case newArrivalMixes
        case myMixes
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(discoveryMixes, forKey: .discoveryMixes)
        try container.encode(newArrivalMixes, forKey: .newArrivalMixes)
        try container.encode(myMixes, forKey: .myMixes)
    }
}


