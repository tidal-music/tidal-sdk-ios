//
// ArtistsRelationships.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** relationships object describing relationships between the resource and other resources */
public struct ArtistsRelationships: Codable, Hashable {

    public var albums: MultiDataRelationshipDoc
    public var tracks: MultiDataRelationshipDoc
    public var videos: MultiDataRelationshipDoc
    public var similarArtists: MultiDataRelationshipDoc
    public var trackProviders: ArtistsTrackProvidersRelationship
    public var radio: MultiDataRelationshipDoc

    public init(albums: MultiDataRelationshipDoc, tracks: MultiDataRelationshipDoc, videos: MultiDataRelationshipDoc, similarArtists: MultiDataRelationshipDoc, trackProviders: ArtistsTrackProvidersRelationship, radio: MultiDataRelationshipDoc) {
        self.albums = albums
        self.tracks = tracks
        self.videos = videos
        self.similarArtists = similarArtists
        self.trackProviders = trackProviders
        self.radio = radio
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case albums
        case tracks
        case videos
        case similarArtists
        case trackProviders
        case radio
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(albums, forKey: .albums)
        try container.encode(tracks, forKey: .tracks)
        try container.encode(videos, forKey: .videos)
        try container.encode(similarArtists, forKey: .similarArtists)
        try container.encode(trackProviders, forKey: .trackProviders)
        try container.encode(radio, forKey: .radio)
    }
}

