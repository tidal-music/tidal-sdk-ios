//
// TrackCreateOperationPayloadDataRelationships.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct TrackCreateOperationPayloadDataRelationships: Codable, Hashable {

    public var albums: TrackCreateOperationPayloadDataRelationshipsAlbums
    public var artists: TrackCreateOperationPayloadDataRelationshipsArtists

    public init(
        albums: TrackCreateOperationPayloadDataRelationshipsAlbums,
        artists: TrackCreateOperationPayloadDataRelationshipsArtists
    ) {
        self.albums = albums
        self.artists = artists
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case albums
        case artists
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(albums, forKey: .albums)
        try container.encode(artists, forKey: .artists)
    }
}


