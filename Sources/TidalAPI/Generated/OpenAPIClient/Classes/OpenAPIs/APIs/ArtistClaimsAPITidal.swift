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
     Get single artistClaim.
     
     - returns: ArtistClaimsSingleResourceDataDocument
     */
	public static func artistClaimsIdGet(id: String, include: [String]? = nil) async throws -> ArtistClaimsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Update single artistClaim.
     
     - returns: 
     */
	public static func artistClaimsIdPatch(id: String, artistClaimsUpdateOperationPayload: ArtistClaimsUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdPatchWithRequestBuilder(id: id, artistClaimsUpdateOperationPayload: artistClaimsUpdateOperationPayload)
		}
	}


	/**
     Get acceptedArtists relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistClaimsMultiRelationshipDataDocument
     */
	public static func artistClaimsIdRelationshipsAcceptedArtistsGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistClaimsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdRelationshipsAcceptedArtistsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Update acceptedArtists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func artistClaimsIdRelationshipsAcceptedArtistsPatch(id: String, artistClaimAcceptedArtistsRelationshipUpdateOperationPayload: ArtistClaimAcceptedArtistsRelationshipUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdRelationshipsAcceptedArtistsPatchWithRequestBuilder(id: id, artistClaimAcceptedArtistsRelationshipUpdateOperationPayload: artistClaimAcceptedArtistsRelationshipUpdateOperationPayload)
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
	public static func artistClaimsIdRelationshipsRecommendedArtistsGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistClaimsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdRelationshipsRecommendedArtistsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single artistClaim.
     
     - returns: ArtistClaimsSingleResourceDataDocument
     */
	public static func artistClaimsPost(artistClaimsCreateOperationPayload: ArtistClaimsCreateOperationPayload? = nil) async throws -> ArtistClaimsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsPostWithRequestBuilder(artistClaimsCreateOperationPayload: artistClaimsCreateOperationPayload)
		}
	}
}
