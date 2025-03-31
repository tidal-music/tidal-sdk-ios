//
// AlbumsRelationships.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct AlbumsRelationships: Codable, Hashable {

    public var artists: MultiDataRelationshipDoc
    public var similarAlbums: MultiDataRelationshipDoc
    public var items: AlbumsItemsMultiDataRelationshipDocument
    public var providers: MultiDataRelationshipDoc

    public init(artists: MultiDataRelationshipDoc, similarAlbums: MultiDataRelationshipDoc, items: AlbumsItemsMultiDataRelationshipDocument, providers: MultiDataRelationshipDoc) {
        self.artists = artists
        self.similarAlbums = similarAlbums
        self.items = items
        self.providers = providers
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case artists
        case similarAlbums
        case items
        case providers
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(artists, forKey: .artists)
        try container.encode(similarAlbums, forKey: .similarAlbums)
        try container.encode(items, forKey: .items)
        try container.encode(providers, forKey: .providers)
    }
}

