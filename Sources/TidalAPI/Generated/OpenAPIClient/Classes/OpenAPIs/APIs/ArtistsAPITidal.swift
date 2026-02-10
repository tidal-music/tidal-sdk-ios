import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ArtistsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtistsAPITidal.getResource()
/// ```
public enum ArtistsAPITidal {


	/**
     Get multiple artists.
     
     - returns: ArtistsMultiResourceDataDocument
     */
	public static func artistsGet(countryCode: String? = nil, include: [String]? = nil, filterHandle: [String]? = nil, filterId: [String]? = nil, filterOwnersId: [String]? = nil) async throws -> ArtistsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsGetWithRequestBuilder(countryCode: countryCode, include: include, filterHandle: filterHandle, filterId: filterId, filterOwnersId: filterOwnersId)
		}
	}


	/**
     Get single artist.
     
     - returns: ArtistsSingleResourceDataDocument
     */
	public static func artistsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> ArtistsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Update single artist.
     
     - returns: 
     */
	public static func artistsIdPatch(id: String, artistsUpdateOperationPayload: ArtistsUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdPatchWithRequestBuilder(id: id, artistsUpdateOperationPayload: artistsUpdateOperationPayload)
		}
	}


	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiRelationshipDataDocument
     */
	public static func artistsIdRelationshipsAlbumsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> ArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsAlbumsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Get biography relationship (\&quot;to-one\&quot;).
     
     - returns: ArtistsSingleRelationshipDataDocument
     */
	public static func artistsIdRelationshipsBiographyGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> ArtistsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsBiographyGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Get followers relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsFollowersMultiRelationshipDataDocument
     */
	public static func artistsIdRelationshipsFollowersGet(id: String, viewerContext: String? = nil, pageCursor: String? = nil, include: [String]? = nil) async throws -> ArtistsFollowersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsFollowersGetWithRequestBuilder(id: id, viewerContext: viewerContext, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Delete from following relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func artistsIdRelationshipsFollowingDelete(id: String, artistsFollowingRelationshipRemoveOperationPayload: ArtistsFollowingRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsFollowingDeleteWithRequestBuilder(id: id, artistsFollowingRelationshipRemoveOperationPayload: artistsFollowingRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get following relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsFollowingMultiRelationshipDataDocument
     */
	public static func artistsIdRelationshipsFollowingGet(id: String, viewerContext: String? = nil, pageCursor: String? = nil, include: [String]? = nil) async throws -> ArtistsFollowingMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsFollowingGetWithRequestBuilder(id: id, viewerContext: viewerContext, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Add to following relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func artistsIdRelationshipsFollowingPost(id: String, countryCode: String? = nil, artistsFollowingRelationshipAddOperationPayload: ArtistsFollowingRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsFollowingPostWithRequestBuilder(id: id, countryCode: countryCode, artistsFollowingRelationshipAddOperationPayload: artistsFollowingRelationshipAddOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiRelationshipDataDocument
     */
	public static func artistsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get profileArt relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiRelationshipDataDocument
     */
	public static func artistsIdRelationshipsProfileArtGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsProfileArtGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Update profileArt relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func artistsIdRelationshipsProfileArtPatch(id: String, artistsProfileArtRelationshipUpdateOperationPayload: ArtistsProfileArtRelationshipUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsProfileArtPatchWithRequestBuilder(id: id, artistsProfileArtRelationshipUpdateOperationPayload: artistsProfileArtRelationshipUpdateOperationPayload)
		}
	}


	/**
     Get radio relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiRelationshipDataDocument
     */
	public static func artistsIdRelationshipsRadioGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> ArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsRadioGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Get roles relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiRelationshipDataDocument
     */
	public static func artistsIdRelationshipsRolesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsRolesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get similarArtists relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiRelationshipDataDocument
     */
	public static func artistsIdRelationshipsSimilarArtistsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> ArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsSimilarArtistsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Get trackProviders relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsTrackProvidersMultiRelationshipDataDocument
     */
	public static func artistsIdRelationshipsTrackProvidersGet(id: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> ArtistsTrackProvidersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsTrackProvidersGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include)
		}
	}


	/**
	 * enum for parameter collapseBy
	 */
	public enum CollapseBy_artistsIdRelationshipsTracksGet: String, CaseIterable {
		case fingerprint = "FINGERPRINT"
		case _none = "NONE"

		func toArtistsAPIEnum() -> ArtistsAPI.CollapseBy_artistsIdRelationshipsTracksGet {
			switch self {
			case .fingerprint: return .fingerprint
			case ._none: return ._none
			}
		}
	}

	/**
     Get tracks relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiRelationshipDataDocument
     */
	public static func artistsIdRelationshipsTracksGet(id: String, collapseBy: ArtistsAPITidal.CollapseBy_artistsIdRelationshipsTracksGet, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> ArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsTracksGetWithRequestBuilder(id: id, collapseBy: collapseBy.toArtistsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Get videos relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiRelationshipDataDocument
     */
	public static func artistsIdRelationshipsVideosGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> ArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsVideosGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Create single artist.
     
     - returns: ArtistsSingleResourceDataDocument
     */
	public static func artistsPost(artistsCreateOperationPayload: ArtistsCreateOperationPayload? = nil) async throws -> ArtistsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsPostWithRequestBuilder(artistsCreateOperationPayload: artistsCreateOperationPayload)
		}
	}
}
