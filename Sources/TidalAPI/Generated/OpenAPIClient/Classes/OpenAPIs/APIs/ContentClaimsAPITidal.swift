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
	public static func contentClaimsGet(include: [String]? = nil, filterOwnersId: [String]? = nil) async throws -> ContentClaimsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ContentClaimsAPI.contentClaimsGetWithRequestBuilder(include: include, filterOwnersId: filterOwnersId)
		}
	}


	/**
     Get single contentClaim.
     
     - returns: ContentClaimsSingleResourceDataDocument
     */
	public static func contentClaimsIdGet(id: String, include: [String]? = nil) async throws -> ContentClaimsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ContentClaimsAPI.contentClaimsIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get claimedResource relationship (\&quot;to-one\&quot;).
     
     - returns: ContentClaimsSingleRelationshipDataDocument
     */
	public static func contentClaimsIdRelationshipsClaimedResourceGet(id: String, include: [String]? = nil) async throws -> ContentClaimsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ContentClaimsAPI.contentClaimsIdRelationshipsClaimedResourceGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get claimingArtist relationship (\&quot;to-one\&quot;).
     
     - returns: ContentClaimsSingleRelationshipDataDocument
     */
	public static func contentClaimsIdRelationshipsClaimingArtistGet(id: String, include: [String]? = nil) async throws -> ContentClaimsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ContentClaimsAPI.contentClaimsIdRelationshipsClaimingArtistGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ContentClaimsMultiRelationshipDataDocument
     */
	public static func contentClaimsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ContentClaimsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ContentClaimsAPI.contentClaimsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single contentClaim.
     
     - returns: ContentClaimsSingleResourceDataDocument
     */
	public static func contentClaimsPost(contentClaimsCreateOperationPayload: ContentClaimsCreateOperationPayload? = nil) async throws -> ContentClaimsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ContentClaimsAPI.contentClaimsPostWithRequestBuilder(contentClaimsCreateOperationPayload: contentClaimsCreateOperationPayload)
		}
	}
}
