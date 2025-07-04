//
// SearchSuggestionsHighlights.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct SearchSuggestionsHighlights: Codable, Hashable {

    public var start: Int
    public var length: Int

    public init(
        start: Int,
        length: Int
    ) {
        self.start = start
        self.length = length
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case start
        case length
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(start, forKey: .start)
        try container.encode(length, forKey: .length)
    }
}


