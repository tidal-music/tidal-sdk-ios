//
// AlbumsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal class AlbumsAPI {

    /**
     Get multiple albums.
     
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: artists, coverArt, items, owners, providers, similarAlbums (optional)
     - parameter filterROwnersId: (query) User id (optional)
     - parameter filterId: (query) Album id (optional)
     - parameter filterBarcodeId: (query) Barcode Id (optional)
     - returns: AlbumsMultiDataDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func albumsGet(countryCode: String, pageCursor: String? = nil, include: [String]? = nil, filterROwnersId: [String]? = nil, filterId: [String]? = nil, filterBarcodeId: [String]? = nil) async throws -> AlbumsMultiDataDocument {
        return try await albumsGetWithRequestBuilder(countryCode: countryCode, pageCursor: pageCursor, include: include, filterROwnersId: filterROwnersId, filterId: filterId, filterBarcodeId: filterBarcodeId).execute().body
    }

    /**
     Get multiple albums.
     - GET /albums
     - Retrieves multiple albums by available filters, or without if applicable.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - OAuth:
       - type: oauth2
       - name: Client_Credentials
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: artists, coverArt, items, owners, providers, similarAlbums (optional)
     - parameter filterROwnersId: (query) User id (optional)
     - parameter filterId: (query) Album id (optional)
     - parameter filterBarcodeId: (query) Barcode Id (optional)
     - returns: RequestBuilder<AlbumsMultiDataDocument> 
     */
    internal class func albumsGetWithRequestBuilder(countryCode: String, pageCursor: String? = nil, include: [String]? = nil, filterROwnersId: [String]? = nil, filterId: [String]? = nil, filterBarcodeId: [String]? = nil) -> RequestBuilder<AlbumsMultiDataDocument> {
        let localVariablePath = "/albums"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
            "page[cursor]": (wrappedValue: pageCursor?.encodeToJSON(), isExplode: true),
            "include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
            "filter[r.owners.id]": (wrappedValue: filterROwnersId?.encodeToJSON(), isExplode: true),
            "filter[id]": (wrappedValue: filterId?.encodeToJSON(), isExplode: true),
            "filter[barcodeId]": (wrappedValue: filterBarcodeId?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<AlbumsMultiDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Delete single album.
     
     - parameter id: (path) Album id 
     - returns: Void
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func albumsIdDelete(id: String) async throws {
        return try await albumsIdDeleteWithRequestBuilder(id: id).execute().body
    }

    /**
     Delete single album.
     - DELETE /albums/{id}
     - Deletes existing album.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - parameter id: (path) Album id 
     - returns: RequestBuilder<Void> 
     */
    internal class func albumsIdDeleteWithRequestBuilder(id: String) -> RequestBuilder<Void> {
        var localVariablePath = "/albums/{id}"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = OpenAPIClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "DELETE", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Get single album.
     
     - parameter id: (path) Album id 
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: artists, coverArt, items, owners, providers, similarAlbums (optional)
     - returns: AlbumsSingleDataDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func albumsIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> AlbumsSingleDataDocument {
        return try await albumsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include).execute().body
    }

    /**
     Get single album.
     - GET /albums/{id}
     - Retrieves single album by id.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - OAuth:
       - type: oauth2
       - name: Client_Credentials
     - parameter id: (path) Album id 
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: artists, coverArt, items, owners, providers, similarAlbums (optional)
     - returns: RequestBuilder<AlbumsSingleDataDocument> 
     */
    internal class func albumsIdGetWithRequestBuilder(id: String, countryCode: String, include: [String]? = nil) -> RequestBuilder<AlbumsSingleDataDocument> {
        var localVariablePath = "/albums/{id}"
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

        let localVariableRequestBuilder: RequestBuilder<AlbumsSingleDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Update single album.
     
     - parameter id: (path) Album id 
     - parameter albumUpdateOperationPayload: (body)  (optional)
     - returns: Void
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func albumsIdPatch(id: String, albumUpdateOperationPayload: AlbumUpdateOperationPayload? = nil) async throws {
        return try await albumsIdPatchWithRequestBuilder(id: id, albumUpdateOperationPayload: albumUpdateOperationPayload).execute().body
    }

    /**
     Update single album.
     - PATCH /albums/{id}
     - Updates existing album.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - parameter id: (path) Album id 
     - parameter albumUpdateOperationPayload: (body)  (optional)
     - returns: RequestBuilder<Void> 
     */
    internal class func albumsIdPatchWithRequestBuilder(id: String, albumUpdateOperationPayload: AlbumUpdateOperationPayload? = nil) -> RequestBuilder<Void> {
        var localVariablePath = "/albums/{id}"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: albumUpdateOperationPayload)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "application/vnd.api+json",
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = OpenAPIClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "PATCH", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Get artists relationship (\"to-many\").
     
     - parameter id: (path) Album id 
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: artists (optional)
     - returns: AlbumsMultiDataRelationshipDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func albumsIdRelationshipsArtistsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
        return try await albumsIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include).execute().body
    }

    /**
     Get artists relationship (\"to-many\").
     - GET /albums/{id}/relationships/artists
     - Retrieves artists relationship.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - OAuth:
       - type: oauth2
       - name: Client_Credentials
     - parameter id: (path) Album id 
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: artists (optional)
     - returns: RequestBuilder<AlbumsMultiDataRelationshipDocument> 
     */
    internal class func albumsIdRelationshipsArtistsGetWithRequestBuilder(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) -> RequestBuilder<AlbumsMultiDataRelationshipDocument> {
        var localVariablePath = "/albums/{id}/relationships/artists"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
            "page[cursor]": (wrappedValue: pageCursor?.encodeToJSON(), isExplode: true),
            "include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<AlbumsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Get coverArt relationship (\"to-many\").
     
     - parameter id: (path) Album id 
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: coverArt (optional)
     - returns: AlbumsMultiDataRelationshipDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func albumsIdRelationshipsCoverArtGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
        return try await albumsIdRelationshipsCoverArtGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include).execute().body
    }

    /**
     Get coverArt relationship (\"to-many\").
     - GET /albums/{id}/relationships/coverArt
     - Retrieves coverArt relationship.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - OAuth:
       - type: oauth2
       - name: Client_Credentials
     - parameter id: (path) Album id 
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: coverArt (optional)
     - returns: RequestBuilder<AlbumsMultiDataRelationshipDocument> 
     */
    internal class func albumsIdRelationshipsCoverArtGetWithRequestBuilder(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) -> RequestBuilder<AlbumsMultiDataRelationshipDocument> {
        var localVariablePath = "/albums/{id}/relationships/coverArt"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
            "page[cursor]": (wrappedValue: pageCursor?.encodeToJSON(), isExplode: true),
            "include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<AlbumsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Update coverArt relationship (\"to-many\").
     
     - parameter id: (path) Album id 
     - parameter albumCoverArtRelationshipUpdateOperationPayload: (body)  (optional)
     - returns: Void
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func albumsIdRelationshipsCoverArtPatch(id: String, albumCoverArtRelationshipUpdateOperationPayload: AlbumCoverArtRelationshipUpdateOperationPayload? = nil) async throws {
        return try await albumsIdRelationshipsCoverArtPatchWithRequestBuilder(id: id, albumCoverArtRelationshipUpdateOperationPayload: albumCoverArtRelationshipUpdateOperationPayload).execute().body
    }

    /**
     Update coverArt relationship (\"to-many\").
     - PATCH /albums/{id}/relationships/coverArt
     - Updates coverArt relationship.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - parameter id: (path) Album id 
     - parameter albumCoverArtRelationshipUpdateOperationPayload: (body)  (optional)
     - returns: RequestBuilder<Void> 
     */
    internal class func albumsIdRelationshipsCoverArtPatchWithRequestBuilder(id: String, albumCoverArtRelationshipUpdateOperationPayload: AlbumCoverArtRelationshipUpdateOperationPayload? = nil) -> RequestBuilder<Void> {
        var localVariablePath = "/albums/{id}/relationships/coverArt"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: albumCoverArtRelationshipUpdateOperationPayload)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "application/vnd.api+json",
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = OpenAPIClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "PATCH", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Get items relationship (\"to-many\").
     
     - parameter id: (path) Album id 
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: items (optional)
     - returns: AlbumsItemsMultiDataRelationshipDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func albumsIdRelationshipsItemsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> AlbumsItemsMultiDataRelationshipDocument {
        return try await albumsIdRelationshipsItemsGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include).execute().body
    }

    /**
     Get items relationship (\"to-many\").
     - GET /albums/{id}/relationships/items
     - Retrieves items relationship.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - OAuth:
       - type: oauth2
       - name: Client_Credentials
     - parameter id: (path) Album id 
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: items (optional)
     - returns: RequestBuilder<AlbumsItemsMultiDataRelationshipDocument> 
     */
    internal class func albumsIdRelationshipsItemsGetWithRequestBuilder(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) -> RequestBuilder<AlbumsItemsMultiDataRelationshipDocument> {
        var localVariablePath = "/albums/{id}/relationships/items"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
            "page[cursor]": (wrappedValue: pageCursor?.encodeToJSON(), isExplode: true),
            "include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<AlbumsItemsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Get owners relationship (\"to-many\").
     
     - parameter id: (path) Album id 
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: owners (optional)
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - returns: AlbumsMultiDataRelationshipDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func albumsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
        return try await albumsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor).execute().body
    }

    /**
     Get owners relationship (\"to-many\").
     - GET /albums/{id}/relationships/owners
     - Retrieves owners relationship.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - parameter id: (path) Album id 
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: owners (optional)
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - returns: RequestBuilder<AlbumsMultiDataRelationshipDocument> 
     */
    internal class func albumsIdRelationshipsOwnersGetWithRequestBuilder(id: String, include: [String]? = nil, pageCursor: String? = nil) -> RequestBuilder<AlbumsMultiDataRelationshipDocument> {
        var localVariablePath = "/albums/{id}/relationships/owners"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
            "page[cursor]": (wrappedValue: pageCursor?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<AlbumsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Get providers relationship (\"to-many\").
     
     - parameter id: (path) Album id 
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: providers (optional)
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - returns: AlbumsMultiDataRelationshipDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func albumsIdRelationshipsProvidersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
        return try await albumsIdRelationshipsProvidersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor).execute().body
    }

    /**
     Get providers relationship (\"to-many\").
     - GET /albums/{id}/relationships/providers
     - Retrieves providers relationship.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - OAuth:
       - type: oauth2
       - name: Client_Credentials
     - parameter id: (path) Album id 
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: providers (optional)
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - returns: RequestBuilder<AlbumsMultiDataRelationshipDocument> 
     */
    internal class func albumsIdRelationshipsProvidersGetWithRequestBuilder(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) -> RequestBuilder<AlbumsMultiDataRelationshipDocument> {
        var localVariablePath = "/albums/{id}/relationships/providers"
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

        let localVariableRequestBuilder: RequestBuilder<AlbumsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Get similarAlbums relationship (\"to-many\").
     
     - parameter id: (path) Album id 
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: similarAlbums (optional)
     - returns: AlbumsMultiDataRelationshipDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func albumsIdRelationshipsSimilarAlbumsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
        return try await albumsIdRelationshipsSimilarAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include).execute().body
    }

    /**
     Get similarAlbums relationship (\"to-many\").
     - GET /albums/{id}/relationships/similarAlbums
     - Retrieves similarAlbums relationship.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - OAuth:
       - type: oauth2
       - name: Client_Credentials
     - parameter id: (path) Album id 
     - parameter countryCode: (query) ISO 3166-1 alpha-2 country code 
     - parameter pageCursor: (query) Server-generated cursor value pointing a certain page of items. Optional, targets first page if not specified (optional)
     - parameter include: (query) Allows the client to customize which related resources should be returned. Available options: similarAlbums (optional)
     - returns: RequestBuilder<AlbumsMultiDataRelationshipDocument> 
     */
    internal class func albumsIdRelationshipsSimilarAlbumsGetWithRequestBuilder(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) -> RequestBuilder<AlbumsMultiDataRelationshipDocument> {
        var localVariablePath = "/albums/{id}/relationships/similarAlbums"
        let idPreEscape = "\(APIHelper.mapValueToPathItem(id))"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "countryCode": (wrappedValue: countryCode.encodeToJSON(), isExplode: true),
            "page[cursor]": (wrappedValue: pageCursor?.encodeToJSON(), isExplode: true),
            "include": (wrappedValue: include?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<AlbumsMultiDataRelationshipDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Create single album.
     
     - parameter albumCreateOperationPayload: (body)  (optional)
     - returns: AlbumsSingleDataDocument
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    internal class func albumsPost(albumCreateOperationPayload: AlbumCreateOperationPayload? = nil) async throws -> AlbumsSingleDataDocument {
        return try await albumsPostWithRequestBuilder(albumCreateOperationPayload: albumCreateOperationPayload).execute().body
    }

    /**
     Create single album.
     - POST /albums
     - Creates a new album.
     - OAuth:
       - type: oauth2
       - name: Authorization_Code_PKCE
     - parameter albumCreateOperationPayload: (body)  (optional)
     - returns: RequestBuilder<AlbumsSingleDataDocument> 
     */
    internal class func albumsPostWithRequestBuilder(albumCreateOperationPayload: AlbumCreateOperationPayload? = nil) -> RequestBuilder<AlbumsSingleDataDocument> {
        let localVariablePath = "/albums"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: albumCreateOperationPayload)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "application/vnd.api+json",
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<AlbumsSingleDataDocument>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}
