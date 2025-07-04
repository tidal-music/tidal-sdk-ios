//
// ArtworkSourceFile.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Artwork source file */
public struct ArtworkSourceFile: Codable, Hashable {

    /** MD5 hash of file to be uploaded */
    public var md5Hash: String
    /** File size of the artwork in bytes */
    public var size: Int64
    public var uploadLink: FileUploadLink
    public var status: FileStatus

    public init(
        md5Hash: String,
        size: Int64,
        uploadLink: FileUploadLink,
        status: FileStatus
    ) {
        self.md5Hash = md5Hash
        self.size = size
        self.uploadLink = uploadLink
        self.status = status
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case md5Hash
        case size
        case uploadLink
        case status
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(md5Hash, forKey: .md5Hash)
        try container.encode(size, forKey: .size)
        try container.encode(uploadLink, forKey: .uploadLink)
        try container.encode(status, forKey: .status)
    }
}


