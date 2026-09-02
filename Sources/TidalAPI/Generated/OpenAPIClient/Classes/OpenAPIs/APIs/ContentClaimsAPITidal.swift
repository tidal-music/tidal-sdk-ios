import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ContentClaimsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ContentClaimsAPITidal.getResource()
/// ```
public enum ContentClaimsAPITidal {


	/**
     Get multiple contentClaims.
     
     - returns: ContentClaimsMultiResourceDataDocument
     */
	public static func contentClaimsGet(filterOwnersId: [String], include: [String]? = nil, replaceMedia: String? = nil) async throws -> ContentClaimsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ContentClaimsAPI.contentClaimsGetWithRequestBuilder(filterOwnersId: filterOwnersId, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get single contentClaim.
     
     - returns: ContentClaimsSingleResourceDataDocument
     */
	public static func contentClaimsIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ContentClaimsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ContentClaimsAPI.contentClaimsIdGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get claimedResource relationship (\&quot;to-one\&quot;).
     
     - returns: ContentClaimsClaimedResourceSingleRelationshipDataDocument
     */
	public static func contentClaimsIdRelationshipsClaimedResourceGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ContentClaimsClaimedResourceSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ContentClaimsAPI.contentClaimsIdRelationshipsClaimedResourceGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get claimingArtist relationship (\&quot;to-one\&quot;).
     
     - returns: ContentClaimsClaimingArtistSingleRelationshipDataDocument
     */
	public static func contentClaimsIdRelationshipsClaimingArtistGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ContentClaimsClaimingArtistSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ContentClaimsAPI.contentClaimsIdRelationshipsClaimingArtistGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ContentClaimsOwnersMultiRelationshipDataDocument
     */
	public static func contentClaimsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ContentClaimsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ContentClaimsAPI.contentClaimsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single contentClaim.
     
     - returns: ContentClaimsCreateSingleResourceDataDocument
     */
	public static func contentClaimsPost(idempotencyKey: String? = nil, contentClaimsCreateOperationPayload: ContentClaimsCreateOperationPayload? = nil) async throws -> ContentClaimsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ContentClaimsAPI.contentClaimsPostWithRequestBuilder(idempotencyKey: idempotencyKey, contentClaimsCreateOperationPayload: contentClaimsCreateOperationPayload)
		}
	}
}
