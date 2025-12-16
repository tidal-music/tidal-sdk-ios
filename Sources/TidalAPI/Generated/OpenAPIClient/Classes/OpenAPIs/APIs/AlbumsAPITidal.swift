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
     
     - returns: AlbumsMultiResourceDataDocument
     */
	public static func albumsGet(pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, filterBarcodeId: [String]? = nil, filterId: [String]? = nil, filterOwnersId: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsGetWithRequestBuilder(pageCursor: pageCursor, countryCode: countryCode, include: include, filterBarcodeId: filterBarcodeId, filterId: filterId, filterOwnersId: filterOwnersId, shareCode: shareCode)
		}
	}


	/**
     Delete single album.
     
     - returns: 
     */
	public static func albumsIdDelete(id: String) async throws {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdDeleteWithRequestBuilder(id: id)
		}
	}


	/**
     Get single album.
     
     - returns: AlbumsSingleResourceDataDocument
     */
	public static func albumsIdGet(id: String, countryCode: String, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, shareCode: shareCode)
		}
	}


	/**
     Update single album.
     
     - returns: 
     */
	public static func albumsIdPatch(id: String, albumUpdateOperationPayload: AlbumUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdPatchWithRequestBuilder(id: id, albumUpdateOperationPayload: albumUpdateOperationPayload)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsArtistsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include, shareCode: shareCode)
		}
	}


	/**
     Get coverArt relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsCoverArtGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsCoverArtGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include, shareCode: shareCode)
		}
	}


	/**
     Update coverArt relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func albumsIdRelationshipsCoverArtPatch(id: String, albumCoverArtRelationshipUpdateOperationPayload: AlbumCoverArtRelationshipUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsCoverArtPatchWithRequestBuilder(id: id, albumCoverArtRelationshipUpdateOperationPayload: albumCoverArtRelationshipUpdateOperationPayload)
		}
	}


	/**
     Get genres relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsGenresGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsGenresGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include, shareCode: shareCode)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsItemsMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsItemsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsItemsGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include, shareCode: shareCode)
		}
	}


	/**
     Update items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func albumsIdRelationshipsItemsPatch(id: String, albumItemsRelationshipUpdateOperationPayload: AlbumItemsRelationshipUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsItemsPatchWithRequestBuilder(id: id, albumItemsRelationshipUpdateOperationPayload: albumItemsRelationshipUpdateOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> AlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get providers relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsProvidersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> AlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsProvidersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get similarAlbums relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsSimilarAlbumsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsSimilarAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include, shareCode: shareCode)
		}
	}


	/**
     Get suggestedCoverArts relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsSuggestedCoverArtsMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsSuggestedCoverArtsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> AlbumsSuggestedCoverArtsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsSuggestedCoverArtsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Create single album.
     
     - returns: AlbumsSingleResourceDataDocument
     */
	public static func albumsPost(albumCreateOperationPayload: AlbumCreateOperationPayload? = nil) async throws -> AlbumsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsPostWithRequestBuilder(albumCreateOperationPayload: albumCreateOperationPayload)
		}
	}
}
