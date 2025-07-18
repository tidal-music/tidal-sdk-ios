import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `AlbumsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await AlbumsAPITidal.getResource()
/// ```
public enum AlbumsAPITidal {


	/**
     Get multiple albums.
     
     - returns: AlbumsMultiDataDocument
     */
	public static func albumsGet(countryCode: String, pageCursor: String? = nil, include: [String]? = nil, filterROwnersId: [String]? = nil, filterId: [String]? = nil, filterBarcodeId: [String]? = nil) async throws -> AlbumsMultiDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsGetWithRequestBuilder(countryCode: countryCode, pageCursor: pageCursor, include: include, filterROwnersId: filterROwnersId, filterId: filterId, filterBarcodeId: filterBarcodeId)
		}
	}


	/**
     Get single album.
     
     - returns: AlbumsSingleDataDocument
     */
	public static func albumsIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> AlbumsSingleDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsMultiDataRelationshipDocument
     */
	public static func albumsIdRelationshipsArtistsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Get coverArt relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsMultiDataRelationshipDocument
     */
	public static func albumsIdRelationshipsCoverArtGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsCoverArtGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsItemsMultiDataRelationshipDocument
     */
	public static func albumsIdRelationshipsItemsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> AlbumsItemsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsItemsGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsMultiDataRelationshipDocument
     */
	public static func albumsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get providers relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsMultiDataRelationshipDocument
     */
	public static func albumsIdRelationshipsProvidersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsProvidersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get similarAlbums relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsMultiDataRelationshipDocument
     */
	public static func albumsIdRelationshipsSimilarAlbumsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsSimilarAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Create single album.
     
     - returns: AlbumsSingleDataDocument
     */
	public static func albumsPost(albumCreateOperationPayload: AlbumCreateOperationPayload? = nil) async throws -> AlbumsSingleDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsPostWithRequestBuilder(albumCreateOperationPayload: albumCreateOperationPayload)
		}
	}
}
