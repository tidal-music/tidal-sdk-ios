//
// LyricsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal class LyricsAPI {

    /**
     Get single lyric.
     
     - parameter id: (path)  
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: owners, track (optional)
     - returns: LyricsSingleDataDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func lyricsIdGet(id: String, include: [String]? = nil) async throws -> LyricsSingleDataDocument {
        return try await lyricsIdGetWithRequestBuilder(id: id, include: include).execute().body
    }

    /**
     Get single lyric.
     - GET /lyrics/{id}
     - Retrieves single lyric by id.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - OAuth:
       - type: oauth2
       - name: Client_Credentials
     - parameter id: (path)  
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: owners, track (optional)
     - returns: RequestBuilder<LyricsSingleDataDocument> 
     */
    internal class func lyricsIdGetWithRequestBuilder(id: String, include: [String]? = nil) -> RequestBuilder<LyricsSingleDataDocument> {
        var localVariablePath = "/lyrics/{id}"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<LyricsSingleDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Get owners relationship (\"to-many\").
     
     - parameter id: (path)  
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: owners (optional)
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - returns: LyricsMultiDataRelationshipDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func lyricsIdRelationshipsOwnersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> LyricsMultiDataRelationshipDocument {
        return try await lyricsIdRelationshipsOwnersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor).execute().body
    }

    /**
     Get owners relationship (\"to-many\").
     - GET /lyrics/{id}/relationships/owners
     - Retrieves owners relationship.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - parameter id: (path)  
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: owners (optional)
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - returns: RequestBuilder<LyricsMultiDataRelationshipDocument> 
     */
    internal class func lyricsIdRelationshipsOwnersGetWithRequestBuilder(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) -> RequestBuilder<LyricsMultiDataRelationshipDocument> {
        var localVariablePath = "/lyrics/{id}/relationships/owners"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
            "include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
            "page[cursor]": (wrappedValue: pageCursor?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<LyricsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Get track relationship (\"to-one\").
     
     - parameter id: (path)  
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: track (optional)
     - returns: LyricsSingletonDataRelationshipDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func lyricsIdRelationshipsTrackGet(id: String, countryCode: String, include: [String]? = nil) async throws -> LyricsSingletonDataRelationshipDocument {
        return try await lyricsIdRelationshipsTrackGetWithRequestBuilder(id: id, countryCode: countryCode, include: include).execute().body
    }

    /**
     Get track relationship (\"to-one\").
     - GET /lyrics/{id}/relationships/track
     - Retrieves track relationship.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - OAuth:
       - type: oauth2
       - name: Client_Credentials
     - parameter id: (path)  
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: track (optional)
     - returns: RequestBuilder<LyricsSingletonDataRelationshipDocument> 
     */
    internal class func lyricsIdRelationshipsTrackGetWithRequestBuilder(id: String, countryCode: String, include: [String]? = nil) -> RequestBuilder<LyricsSingletonDataRelationshipDocument> {
        var localVariablePath = "/lyrics/{id}/relationships/track"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
            "include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<LyricsSingletonDataRelationshipDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}
