//
// AvailableTrackRelationships.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Available track relationships */
public struct AvailableTrackRelationships: Codable, Hashable {

    public var albums: ResourceRelationship?
    public var artists: ResourceRelationship?
    public var similarTracks: ResourceRelationship?
    public var providers: ResourceRelationship?

    public init(albums: ResourceRelationship? = nil, artists: ResourceRelationship? = nil, similarTracks: ResourceRelationship? = nil, providers: ResourceRelationship? = nil) {
        self.albums = albums
        self.artists = artists
        self.similarTracks = similarTracks
        self.providers = providers
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case albums
        case artists
        case similarTracks
        case providers
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(albums, forKey: .albums)
        try container.encodeIfPresent(artists, forKey: .artists)
        try container.encodeIfPresent(similarTracks, forKey: .similarTracks)
        try container.encodeIfPresent(providers, forKey: .providers)
    }
}

