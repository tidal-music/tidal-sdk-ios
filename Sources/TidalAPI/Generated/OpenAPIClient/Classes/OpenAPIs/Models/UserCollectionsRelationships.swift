//
// UserCollectionsRelationships.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct UserCollectionsRelationships: Codable, Hashable {

    public var albums: UserCollectionsAlbumsMultiDataRelationshipDocument
    public var artists: UserCollectionsArtistsMultiDataRelationshipDocument
    public var owners: MultiDataRelationshipDoc
    public var playlists: UserCollectionsPlaylistsMultiDataRelationshipDocument

    public init(
        albums: UserCollectionsAlbumsMultiDataRelationshipDocument,
        artists: UserCollectionsArtistsMultiDataRelationshipDocument,
        owners: MultiDataRelationshipDoc,
        playlists: UserCollectionsPlaylistsMultiDataRelationshipDocument
    ) {
        self.albums = albums
        self.artists = artists
        self.owners = owners
        self.playlists = playlists
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case albums
        case artists
        case owners
        case playlists
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(albums, forKey: .albums)
        try container.encode(artists, forKey: .artists)
        try container.encode(owners, forKey: .owners)
        try container.encode(playlists, forKey: .playlists)
    }
}


