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
     Relationship: artists
     
     - returns: ArtistsRelationshipDocument
     */
	public static func getAlbumArtistsRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.getAlbumArtistsRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get single album
     
     - returns: AlbumsSingleDataDocument
     */
	public static func getAlbumById(id: String, countryCode: String, include: [String]? = nil) async throws -> AlbumsSingleDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.getAlbumByIdWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Relationship: items
     
     - returns: AlbumsItemsRelationshipDocument
     */
	public static func getAlbumItemsRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumsItemsRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.getAlbumItemsRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: providers
     
     - returns: ProvidersRelationshipDocument
     */
	public static func getAlbumProvidersRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ProvidersRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.getAlbumProvidersRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: similar albums
     
     - returns: AlbumsRelationshipDocument
     */
	public static func getAlbumSimilarAlbumsRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumsRelationshipDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.getAlbumSimilarAlbumsRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get multiple albums
     
     - returns: AlbumsMultiDataDocument
     */
	public static func getAlbumsByFilters(countryCode: String, include: [String]? = nil, filterId: [String]? = nil, filterBarcodeId: [String]? = nil) async throws -> AlbumsMultiDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.getAlbumsByFiltersWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId, filterBarcodeId: filterBarcodeId)
		}
	}
}
