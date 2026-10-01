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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_artistClaimsGet: String, CaseIterable {
		case acceptedartists = "acceptedArtists"
		case owners = "owners"
		case recommendedartists = "recommendedArtists"

		func toArtistClaimsAPIEnum() -> ArtistClaimsAPI.IncludeLinkage_artistClaimsGet {
			switch self {
			case .acceptedartists: return .acceptedartists
			case .owners: return .owners
			case .recommendedartists: return .recommendedartists
			}
		}
	}

	/**
     Get multiple artistClaims.
     
     - returns: ArtistClaimsMultiResourceDataDocument
     */
	public static func artistClaimsGet(filterOwnersId: [String], include: [String]? = nil, includeLinkage: [ArtistClaimsAPITidal.IncludeLinkage_artistClaimsGet]? = nil, replaceMedia: String? = nil) async throws -> ArtistClaimsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsGetWithRequestBuilder(filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage?.compactMap { $0.toArtistClaimsAPIEnum() }, replaceMedia: replaceMedia)
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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_artistClaimsIdGet: String, CaseIterable {
		case acceptedartists = "acceptedArtists"
		case owners = "owners"
		case recommendedartists = "recommendedArtists"

		func toArtistClaimsAPIEnum() -> ArtistClaimsAPI.IncludeLinkage_artistClaimsIdGet {
			switch self {
			case .acceptedartists: return .acceptedartists
			case .owners: return .owners
			case .recommendedartists: return .recommendedartists
			}
		}
	}

	/**
     Get single artistClaim.
     
     - returns: ArtistClaimsSingleResourceDataDocument
     */
	public static func artistClaimsIdGet(id: String, include: [String]? = nil, includeLinkage: [ArtistClaimsAPITidal.IncludeLinkage_artistClaimsIdGet]? = nil, replaceMedia: String? = nil) async throws -> ArtistClaimsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toArtistClaimsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Update single artistClaim.
     
     - returns: MutationResponseDocument
     */
	public static func artistClaimsIdPatch(id: String, idempotencyKey: String? = nil, artistClaimsUpdateOperationPayload: ArtistClaimsUpdateOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, artistClaimsUpdateOperationPayload: artistClaimsUpdateOperationPayload)
		}
	}


	/**
     Get acceptedArtists relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistClaimsAcceptedArtistsMultiRelationshipDataDocument
     */
	public static func artistClaimsIdRelationshipsAcceptedArtistsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ArtistClaimsAcceptedArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdRelationshipsAcceptedArtistsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Update acceptedArtists relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func artistClaimsIdRelationshipsAcceptedArtistsPatch(id: String, idempotencyKey: String? = nil, artistClaimsAcceptedArtistsRelationshipUpdateOperationPayload: ArtistClaimsAcceptedArtistsRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdRelationshipsAcceptedArtistsPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, artistClaimsAcceptedArtistsRelationshipUpdateOperationPayload: artistClaimsAcceptedArtistsRelationshipUpdateOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistClaimsOwnersMultiRelationshipDataDocument
     */
	public static func artistClaimsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistClaimsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get recommendedArtists relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistClaimsRecommendedArtistsMultiRelationshipDataDocument
     */
	public static func artistClaimsIdRelationshipsRecommendedArtistsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ArtistClaimsRecommendedArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsIdRelationshipsRecommendedArtistsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Create single artistClaim.
     
     - returns: ArtistClaimsCreateSingleResourceDataDocument
     */
	public static func artistClaimsPost(idempotencyKey: String? = nil, artistClaimsCreateOperationPayload: ArtistClaimsCreateOperationPayload? = nil) async throws -> ArtistClaimsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimsAPI.artistClaimsPostWithRequestBuilder(idempotencyKey: idempotencyKey, artistClaimsCreateOperationPayload: artistClaimsCreateOperationPayload)
		}
	}
}
