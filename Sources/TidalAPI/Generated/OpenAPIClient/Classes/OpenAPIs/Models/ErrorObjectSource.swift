//
// ErrorObjectSource.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** object containing references to the primary source of the error */
public struct ErrorObjectSource: Codable, Hashable {

    /** string indicating the name of a single request header which caused the error */
    public var header: String?
    /** string indicating which URI query parameter caused the error. */
    public var parameter: String?
    /** a JSON Pointer [RFC6901] to the value in the request document that caused the error */
    public var pointer: String?

    public init(
        header: String? = nil,
        parameter: String? = nil,
        pointer: String? = nil
    ) {
        self.header = header
        self.parameter = parameter
        self.pointer = pointer
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case header
        case parameter
        case pointer
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(header, forKey: .header)
        try container.encodeIfPresent(parameter, forKey: .parameter)
        try container.encodeIfPresent(pointer, forKey: .pointer)
    }
}


