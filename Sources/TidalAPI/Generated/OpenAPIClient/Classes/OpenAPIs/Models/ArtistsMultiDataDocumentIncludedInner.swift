//
// ArtistsMultiDataDocumentIncludedInner.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public enum ArtistsMultiDataDocumentIncludedInner: Codable, JSONEncodable, Hashable {
	case typeAlbumsResource(AlbumsResource)
	case typeArtistRolesResource(ArtistRolesResource)
	case typeArtistsResource(ArtistsResource)
	case typeArtworksResource(ArtworksResource)
	case typePlaylistsResource(PlaylistsResource)
	case typeProvidersResource(ProvidersResource)
	case typeTracksResource(TracksResource)
	case typeVideosResource(VideosResource)

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .typeAlbumsResource(let value):
			try container.encode(value)
		case .typeArtistRolesResource(let value):
			try container.encode(value)
		case .typeArtistsResource(let value):
			try container.encode(value)
		case .typeArtworksResource(let value):
			try container.encode(value)
		case .typePlaylistsResource(let value):
			try container.encode(value)
		case .typeProvidersResource(let value):
			try container.encode(value)
		case .typeTracksResource(let value):
			try container.encode(value)
		case .typeVideosResource(let value):
			try container.encode(value)
		}
	}
	
	private enum CodingKeys: String, CodingKey {
		case type
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let type = try container.decode(String.self, forKey: .type)

		switch type {
		case "albums":
			let value = try AlbumsResource(from: decoder)
			self = .typeAlbumsResource(value)
		case "artistRoles":
			let value = try ArtistRolesResource(from: decoder)
			self = .typeArtistRolesResource(value)
		case "artists":
			let value = try ArtistsResource(from: decoder)
			self = .typeArtistsResource(value)
		case "artworks":
			let value = try ArtworksResource(from: decoder)
			self = .typeArtworksResource(value)
		case "playlists":
			let value = try PlaylistsResource(from: decoder)
			self = .typePlaylistsResource(value)
		case "providers":
			let value = try ProvidersResource(from: decoder)
			self = .typeProvidersResource(value)
		case "tracks":
			let value = try TracksResource(from: decoder)
			self = .typeTracksResource(value)
		case "videos":
			let value = try VideosResource(from: decoder)
			self = .typeVideosResource(value)
		default:
			throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown type: \\(type)")
		}
	}
}

@available(iOS 13, tvOS 13, watchOS 6, macOS 10.15, *)
extension ArtistsMultiDataDocumentIncludedInner: Identifiable {
	public var id: String {
		switch self {
		case .typeAlbumsResource(let value): return value.id
		case .typeArtistRolesResource(let value): return value.id
		case .typeArtistsResource(let value): return value.id
		case .typeArtworksResource(let value): return value.id
		case .typePlaylistsResource(let value): return value.id
		case .typeProvidersResource(let value): return value.id
		case .typeTracksResource(let value): return value.id
		case .typeVideosResource(let value): return value.id
		}
	}
}


