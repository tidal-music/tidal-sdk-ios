//
// UsersSingleDataDocumentIncludedInner.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public enum UsersSingleDataDocumentIncludedInner: Codable, JSONEncodable, Hashable {
    case typeUserEntitlementsResource(UserEntitlementsResource)
    case typeUserPublicProfilesResource(UserPublicProfilesResource)
    case typeUserRecommendationsResource(UserRecommendationsResource)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .typeUserEntitlementsResource(let value):
            try container.encode(value)
        case .typeUserPublicProfilesResource(let value):
            try container.encode(value)
        case .typeUserRecommendationsResource(let value):
            try container.encode(value)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(UserEntitlementsResource.self) {
            self = .typeUserEntitlementsResource(value)
        } else if let value = try? container.decode(UserPublicProfilesResource.self) {
            self = .typeUserPublicProfilesResource(value)
        } else if let value = try? container.decode(UserRecommendationsResource.self) {
            self = .typeUserRecommendationsResource(value)
        } else {
            throw DecodingError.typeMismatch(Self.Type.self, .init(codingPath: decoder.codingPath, debugDescription: "Unable to decode instance of UsersSingleDataDocumentIncludedInner"))
        }
    }
}

