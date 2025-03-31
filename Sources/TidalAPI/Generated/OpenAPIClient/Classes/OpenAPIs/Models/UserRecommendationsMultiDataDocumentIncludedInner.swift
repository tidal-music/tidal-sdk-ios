//
// UserRecommendationsMultiDataDocumentIncludedInner.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public enum UserRecommendationsMultiDataDocumentIncludedInner: Codable, JSONEncodable, Hashable {
    case typePlaylistsResource(PlaylistsResource)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .typePlaylistsResource(let value):
            try container.encode(value)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(PlaylistsResource.self) {
            self = .typePlaylistsResource(value)
        } else {
            throw DecodingError.typeMismatch(Self.Type.self, .init(codingPath: decoder.codingPath, debugDescription: "Unable to decode instance of UserRecommendationsMultiDataDocumentIncludedInner"))
        }
    }
}


@available(iOS 13, tvOS 13, watchOS 6, macOS 10.15, *)
extension UserRecommendationsMultiDataDocumentIncludedInner: Identifiable {}
