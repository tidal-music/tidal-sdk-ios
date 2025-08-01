//
// AlbumCreateOperationPayloadDataAttributes.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct AlbumCreateOperationPayloadDataAttributes: Codable, Hashable {

    public static let genresRule = ArrayRule(minItems: 0, maxItems: 5, uniqueItems: false)
    public static let titleRule = StringRule(minLength: 1, maxLength: 300, pattern: nil)
    public static let upcRule = StringRule(minLength: 12, maxLength: 13, pattern: nil)
    public static let versionRule = StringRule(minLength: 0, maxLength: 300, pattern: nil)
    public var copyright: AlbumCreateOperationPayloadDataAttributesCopyright?
    public var explicitLyrics: Bool?
    public var genres: [String]?
    public var releaseDate: Date?
    public var title: String
    public var upc: String?
    public var version: String?

    public init(
        copyright: AlbumCreateOperationPayloadDataAttributesCopyright? = nil,
        explicitLyrics: Bool? = nil,
        genres: [String]? = nil,
        releaseDate: Date? = nil,
        title: String,
        upc: String? = nil,
        version: String? = nil
    ) {
        self.copyright = copyright
        self.explicitLyrics = explicitLyrics
        self.genres = genres
        self.releaseDate = releaseDate
        self.title = title
        self.upc = upc
        self.version = version
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case copyright
        case explicitLyrics
        case genres
        case releaseDate
        case title
        case upc
        case version
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(copyright, forKey: .copyright)
        try container.encodeIfPresent(explicitLyrics, forKey: .explicitLyrics)
        try container.encodeIfPresent(genres, forKey: .genres)
        try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(upc, forKey: .upc)
        try container.encodeIfPresent(version, forKey: .version)
    }
}


