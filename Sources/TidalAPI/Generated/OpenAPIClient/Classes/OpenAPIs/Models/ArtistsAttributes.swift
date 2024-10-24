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

/** attributes object representing some of the resource&#39;s data */
public struct ArtistsAttributes: Codable, Hashable {

    /** Artist name */
    public var name: String
    /** Artist popularity (ranged in 0.00 ... 1.00). Conditionally visible */
    public var popularity: Double
    /** Represents available links to, and metadata about, an artist images */
    public var imageLinks: [CatalogueItemImageLink]?
    /** Represents available links to something that is related to an artist resource, but external to the TIDAL API */
    public var externalLinks: [CatalogueItemExternalLink]?

    public init(name: String, popularity: Double, imageLinks: [CatalogueItemImageLink]? = nil, externalLinks: [CatalogueItemExternalLink]? = nil) {
        self.name = name
        self.popularity = popularity
        self.imageLinks = imageLinks
        self.externalLinks = externalLinks
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case popularity
        case imageLinks
        case externalLinks
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(popularity, forKey: .popularity)
        try container.encodeIfPresent(imageLinks, forKey: .imageLinks)
        try container.encodeIfPresent(externalLinks, forKey: .externalLinks)
    }
}

