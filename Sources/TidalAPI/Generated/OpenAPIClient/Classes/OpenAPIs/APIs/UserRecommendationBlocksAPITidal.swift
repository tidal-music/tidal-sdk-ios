import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserRecommendationBlocksAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserRecommendationBlocksAPITidal.getResource()
/// ```
public enum UserRecommendationBlocksAPITidal {


	/**
     Get single userRecommendationBlock.
     
     - returns: UserRecommendationBlocksSingleResourceDataDocument
     */
	public static func userRecommendationBlocksIdGet(id: String, locale: String? = nil, include: [String]? = nil) async throws -> UserRecommendationBlocksSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdGetWithRequestBuilder(id: id, locale: locale, include: include)
		}
	}


	/**
     Delete from artists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userRecommendationBlocksIdRelationshipsArtistsDelete(id: String, idempotencyKey: String? = nil, userRecommendationBlocksArtistsRelationshipRemoveOperationPayload: UserRecommendationBlocksArtistsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsArtistsDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userRecommendationBlocksArtistsRelationshipRemoveOperationPayload: userRecommendationBlocksArtistsRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksArtistsMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsArtistsGet(id: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> UserRecommendationBlocksArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsArtistsGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Add to artists relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksArtistsMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsArtistsPost(id: String, idempotencyKey: String? = nil, userRecommendationBlocksArtistsRelationshipAddOperationPayload: UserRecommendationBlocksArtistsRelationshipAddOperationPayload? = nil) async throws -> UserRecommendationBlocksArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsArtistsPostWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userRecommendationBlocksArtistsRelationshipAddOperationPayload: userRecommendationBlocksArtistsRelationshipAddOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserRecommendationBlocksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Delete from tracks relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userRecommendationBlocksIdRelationshipsTracksDelete(id: String, idempotencyKey: String? = nil, userRecommendationBlocksTracksRelationshipRemoveOperationPayload: UserRecommendationBlocksTracksRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsTracksDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userRecommendationBlocksTracksRelationshipRemoveOperationPayload: userRecommendationBlocksTracksRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get tracks relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksTracksMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsTracksGet(id: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> UserRecommendationBlocksTracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsTracksGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Add to tracks relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksTracksMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsTracksPost(id: String, idempotencyKey: String? = nil, userRecommendationBlocksTracksRelationshipAddOperationPayload: UserRecommendationBlocksTracksRelationshipAddOperationPayload? = nil) async throws -> UserRecommendationBlocksTracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsTracksPostWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userRecommendationBlocksTracksRelationshipAddOperationPayload: userRecommendationBlocksTracksRelationshipAddOperationPayload)
		}
	}


	/**
     Delete from videos relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userRecommendationBlocksIdRelationshipsVideosDelete(id: String, idempotencyKey: String? = nil, userRecommendationBlocksVideosRelationshipRemoveOperationPayload: UserRecommendationBlocksVideosRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsVideosDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userRecommendationBlocksVideosRelationshipRemoveOperationPayload: userRecommendationBlocksVideosRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get videos relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksVideosMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsVideosGet(id: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> UserRecommendationBlocksVideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsVideosGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Add to videos relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksVideosMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsVideosPost(id: String, idempotencyKey: String? = nil, userRecommendationBlocksVideosRelationshipAddOperationPayload: UserRecommendationBlocksVideosRelationshipAddOperationPayload? = nil) async throws -> UserRecommendationBlocksVideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsVideosPostWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userRecommendationBlocksVideosRelationshipAddOperationPayload: userRecommendationBlocksVideosRelationshipAddOperationPayload)
		}
	}
}
