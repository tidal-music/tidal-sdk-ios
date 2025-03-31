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
     Get all albums
     
     - returns: AlbumsMultiDataDocument
     */
	public static func albumsGet(countryCode: String, include: [String]? = nil, filterBarcodeId: [String]? = nil, filterId: [String]? = nil) async throws -> AlbumsMultiDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsGetWithRequestBuilder(countryCode: countryCode, include: include, filterBarcodeId: filterBarcodeId, filterId: filterId)
		}
	}


	/**
     Get single album
     
     - returns: AlbumsSingleDataDocument
     */
	public static func albumsIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> AlbumsSingleDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Relationship: artists
     
     - returns: AlbumsMultiDataRelationshipDocument
     */
	public static func albumsIdRelationshipsArtistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: items
     
     - returns: AlbumsMultiDataRelationshipDocument
     */
	public static func albumsIdRelationshipsItemsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsItemsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: providers
     
     - returns: AlbumsMultiDataRelationshipDocument
     */
	public static func albumsIdRelationshipsProvidersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsProvidersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: similarAlbums
     
     - returns: AlbumsMultiDataRelationshipDocument
     */
	public static func albumsIdRelationshipsSimilarAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsSimilarAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}
}
