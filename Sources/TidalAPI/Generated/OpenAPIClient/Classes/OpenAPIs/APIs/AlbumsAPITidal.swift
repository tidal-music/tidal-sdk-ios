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
	 * enum for parameter sort
	 */
	public enum Sort_albumsGet: String, CaseIterable {
		case CreatedAtAsc = "createdAt"
		case CreatedAtDesc = "-createdAt"
		case TitleAsc = "title"
		case TitleDesc = "-title"

		func toAlbumsAPIEnum() -> AlbumsAPI.Sort_albumsGet {
			switch self {
			case .CreatedAtAsc: return .CreatedAtAsc
			case .CreatedAtDesc: return .CreatedAtDesc
			case .TitleAsc: return .TitleAsc
			case .TitleDesc: return .TitleDesc
			}
		}
	}

	/**
     Get multiple albums.
     
     - returns: AlbumsMultiResourceDataDocument
     */
	public static func albumsGet(pageCursor: String? = nil, sort: [AlbumsAPITidal.Sort_albumsGet]? = nil, countryCode: String? = nil, include: [String]? = nil, filterBarcodeId: [String]? = nil, filterId: [String]? = nil, filterOwnersId: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsGetWithRequestBuilder(pageCursor: pageCursor, sort: sort?.compactMap { $0.toAlbumsAPIEnum() }, countryCode: countryCode, include: include, filterBarcodeId: filterBarcodeId, filterId: filterId, filterOwnersId: filterOwnersId, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Delete single album.
     
     - returns: MutationResponseDocument
     */
	public static func albumsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
     Get single album.
     
     - returns: AlbumsSingleResourceDataDocument
     */
	public static func albumsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Update single album.
     
     - returns: MutationResponseDocument
     */
	public static func albumsIdPatch(id: String, idempotencyKey: String? = nil, albumsUpdateOperationPayload: AlbumsUpdateOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, albumsUpdateOperationPayload: albumsUpdateOperationPayload)
		}
	}


	/**
     Get albumStatistics relationship (\&quot;to-one\&quot;).
     
     - returns: AlbumsAlbumStatisticsSingleRelationshipDataDocument
     */
	public static func albumsIdRelationshipsAlbumStatisticsGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsAlbumStatisticsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsAlbumStatisticsGetWithRequestBuilder(id: id, include: include, shareCode: shareCode)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsArtistsMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsArtistsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsArtistsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get coverArt relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsCoverArtMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsCoverArtGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsCoverArtMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsCoverArtGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, shareCode: shareCode)
		}
	}


	/**
     Update coverArt relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func albumsIdRelationshipsCoverArtPatch(id: String, idempotencyKey: String? = nil, albumsCoverArtRelationshipUpdateOperationPayload: AlbumsCoverArtRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsCoverArtPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, albumsCoverArtRelationshipUpdateOperationPayload: albumsCoverArtRelationshipUpdateOperationPayload)
		}
	}


	/**
     Get genres relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsGenresMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsGenresGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsGenresMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsGenresGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, shareCode: shareCode)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsItemsMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Update items relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func albumsIdRelationshipsItemsPatch(id: String, idempotencyKey: String? = nil, albumsItemsRelationshipUpdateOperationPayload: AlbumsItemsRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsItemsPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, albumsItemsRelationshipUpdateOperationPayload: albumsItemsRelationshipUpdateOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsOwnersMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsOwnersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> AlbumsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsOwnersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get priceConfig relationship (\&quot;to-one\&quot;).
     
     - returns: AlbumsPriceConfigSingleRelationshipDataDocument
     */
	public static func albumsIdRelationshipsPriceConfigGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsPriceConfigSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsPriceConfigGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, shareCode: shareCode)
		}
	}


	/**
     Get providers relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsProvidersMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsProvidersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> AlbumsProvidersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsProvidersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get replacement relationship (\&quot;to-one\&quot;).
     
     - returns: AlbumsReplacementSingleRelationshipDataDocument
     */
	public static func albumsIdRelationshipsReplacementGet(id: String, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsReplacementSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsReplacementGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get shares relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsSharesMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsSharesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsSharesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsSharesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get similarAlbums relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumsSimilarAlbumsMultiRelationshipDataDocument
     */
	public static func albumsIdRelationshipsSimilarAlbumsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> AlbumsSimilarAlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsSimilarAlbumsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
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
     Get usageRules relationship (\&quot;to-one\&quot;).
     
     - returns: AlbumsUsageRulesSingleRelationshipDataDocument
     */
	public static func albumsIdRelationshipsUsageRulesGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> AlbumsUsageRulesSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsIdRelationshipsUsageRulesGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, shareCode: shareCode)
		}
	}


	/**
     Create single album.
     
     - returns: AlbumsCreateSingleResourceDataDocument
     */
	public static func albumsPost(idempotencyKey: String? = nil, albumsCreateOperationPayload: AlbumsCreateOperationPayload? = nil) async throws -> AlbumsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			AlbumsAPI.albumsPostWithRequestBuilder(idempotencyKey: idempotencyKey, albumsCreateOperationPayload: albumsCreateOperationPayload)
		}
	}
}
