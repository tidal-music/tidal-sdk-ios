//
// AlbumsMultiDataDocumentIncludedInner.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public enum AlbumsMultiDataDocumentIncludedInner: Codable, JSONEncodable, Hashable {
    case typeAlbumsResource(AlbumsResource)
    case typeArtistsResource(ArtistsResource)
    case typeProvidersResource(ProvidersResource)
    case typeTracksResource(TracksResource)
    case typeVideosResource(VideosResource)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .typeAlbumsResource(let value):
            try container.encode(value)
        case .typeArtistsResource(let value):
            try container.encode(value)
        case .typeProvidersResource(let value):
            try container.encode(value)
        case .typeTracksResource(let value):
            try container.encode(value)
        case .typeVideosResource(let value):
            try container.encode(value)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(AlbumsResource.self) {
            self = .typeAlbumsResource(value)
        } else if let value = try? container.decode(ArtistsResource.self) {
            self = .typeArtistsResource(value)
        } else if let value = try? container.decode(ProvidersResource.self) {
            self = .typeProvidersResource(value)
        } else if let value = try? container.decode(TracksResource.self) {
            self = .typeTracksResource(value)
        } else if let value = try? container.decode(VideosResource.self) {
            self = .typeVideosResource(value)
        } else {
            throw DecodingError.typeMismatch(Self.Type.self, .init(codingPath: decoder.codingPath, debugDescription: "Unable to decode instance of AlbumsMultiDataDocumentIncludedInner"))
        }
    }
}

@available(iOS 13, tvOS 13, watchOS 6, macOS 10.15, *)
extension AlbumsMultiDataDocumentIncludedInner: Identifiable {
	public var id: some Hashable {
		switch self {
		case let .typeAlbumsResource(value):
			value.id
		case let .typeArtistsResource(value):
			value.id
		case let .typeProvidersResource(value):
			value.id
		case let .typeTracksResource(value):
			value.id
		case let .typeVideosResource(value):
			value.id
		}
	}
}
