//
// UserEntitlementsAttributes.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct UserEntitlementsAttributes: Codable, Hashable {

    public enum Entitlements: String, Codable, CaseIterable {
        case music = "MUSIC"
        case dj = "DJ"
    }
    /** entitlements for user */
    public var entitlements: [Entitlements]

    public init(entitlements: [Entitlements]) {
        self.entitlements = entitlements
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case entitlements
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entitlements, forKey: .entitlements)
    }
}


