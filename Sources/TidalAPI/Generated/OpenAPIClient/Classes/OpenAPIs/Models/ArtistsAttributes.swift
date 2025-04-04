//
// ArtistsAttributes.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ArtistsAttributes: Codable, Hashable {

    public enum Roles: String, Codable, CaseIterable {
        case artist = "ARTIST"
        case songwriter = "SONGWRITER"
        case engineer = "ENGINEER"
        case productionTeam = "PRODUCTION_TEAM"
        case performer = "PERFORMER"
        case producer = "PRODUCER"
        case misc = "MISC"
    }
    /** Artist name */
    public var name: String
    /** Artist popularity (0.0 - 1.0) */
    public var popularity: Double
    /** Artist image links and metadata */
    public var imageLinks: [ImageLink]?
    /** Artist links external to TIDAL API */
    public var externalLinks: [ExternalLink]?
    /** Artist roles */
    @available(*, deprecated, message: "This property is deprecated.")
    public var roles: [Roles]?
    /** Artist handle */
    public var handle: String?

    public init(name: String, popularity: Double, imageLinks: [ImageLink]? = nil, externalLinks: [ExternalLink]? = nil, roles: [Roles]? = nil, handle: String? = nil) {
        self.name = name
        self.popularity = popularity
        self.imageLinks = imageLinks
        self.externalLinks = externalLinks
        self.roles = roles
        self.handle = handle
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case popularity
        case imageLinks
        case externalLinks
        case roles
        case handle
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(popularity, forKey: .popularity)
        try container.encodeIfPresent(imageLinks, forKey: .imageLinks)
        try container.encodeIfPresent(externalLinks, forKey: .externalLinks)
        try container.encodeIfPresent(roles, forKey: .roles)
        try container.encodeIfPresent(handle, forKey: .handle)
    }
}

