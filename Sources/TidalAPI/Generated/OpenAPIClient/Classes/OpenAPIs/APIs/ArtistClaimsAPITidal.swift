import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ArtistClaimsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtistClaimsAPITidal.getResource()
/// ```
public enum ArtistClaimsAPITidal {


	/**
     Get multiple artistClaims.
     
     - returns: ArtistClaimsMultiResourceDataDocument
     */
	public static func artistClaimsGet(filterOwnersId: [String], include: [String]? = nil, replaceMedia: String? = nil) async throws -> ArtistClaimsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsGetWithRequestBuilder(filterOwnersId: filterOwnersId, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Delete single artistClaim.
     
     - returns: MutationResponseDocument
     */
	public static func artistClaimsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
     Get single artistClaim.
     
     - returns: ArtistClaimsSingleResourceDataDocument
     */
	public static func artistClaimsIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ArtistClaimsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Update single artistClaim.
     
     - returns: MutationResponseDocument
     */
	public static func artistClaimsIdPatch(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, artistClaimsUpdateOperationPayload: ArtistClaimsUpdateOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdPatchWithRequestBuilder(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, artistClaimsUpdateOperationPayload: artistClaimsUpdateOperationPayload)
		}
	}


	/**
     Get acceptedArtists relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistClaimsMultiRelationshipDataDocument
     */
	public static func artistClaimsIdRelationshipsAcceptedArtistsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ArtistClaimsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdRelationshipsAcceptedArtistsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Update acceptedArtists relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func artistClaimsIdRelationshipsAcceptedArtistsPatch(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, artistClaimsAcceptedArtistsRelationshipUpdateOperationPayload: ArtistClaimsAcceptedArtistsRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdRelationshipsAcceptedArtistsPatchWithRequestBuilder(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, artistClaimsAcceptedArtistsRelationshipUpdateOperationPayload: artistClaimsAcceptedArtistsRelationshipUpdateOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistClaimsMultiRelationshipDataDocument
     */
	public static func artistClaimsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistClaimsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get recommendedArtists relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistClaimsMultiRelationshipDataDocument
     */
	public static func artistClaimsIdRelationshipsRecommendedArtistsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ArtistClaimsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdRelationshipsRecommendedArtistsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Create single artistClaim.
     
     - returns: ArtistClaimsCreateSingleResourceDataDocument
     */
	public static func artistClaimsPost(countryCode: String? = nil, idempotencyKey: String? = nil, artistClaimsCreateOperationPayload: ArtistClaimsCreateOperationPayload? = nil) async throws -> ArtistClaimsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsPostWithRequestBuilder(countryCode: countryCode, idempotencyKey: idempotencyKey, artistClaimsCreateOperationPayload: artistClaimsCreateOperationPayload)
		}
	}
}
