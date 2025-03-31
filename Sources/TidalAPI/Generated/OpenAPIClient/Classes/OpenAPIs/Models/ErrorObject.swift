//
// ErrorObject.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** JSON:API error object */
public struct ErrorObject: Codable, Hashable {

    /** unique identifier for this particular occurrence of the problem */
    public var id: String?
    /** HTTP status code applicable to this problem */
    public var status: String?
    /** application-specific error code */
    public var code: String?
    /** human-readable explanation specific to this occurrence of the problem */
    public var detail: String?
    public var source: ErrorObjectSource?

    public init(id: String? = nil, status: String? = nil, code: String? = nil, detail: String? = nil, source: ErrorObjectSource? = nil) {
        self.id = id
        self.status = status
        self.code = code
        self.detail = detail
        self.source = source
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case status
        case code
        case detail
        case source
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(code, forKey: .code)
        try container.encodeIfPresent(detail, forKey: .detail)
        try container.encodeIfPresent(source, forKey: .source)
    }
}


@available(iOS 13, tvOS 13, watchOS 6, macOS 10.15, *)
extension ErrorObject: Identifiable {}
