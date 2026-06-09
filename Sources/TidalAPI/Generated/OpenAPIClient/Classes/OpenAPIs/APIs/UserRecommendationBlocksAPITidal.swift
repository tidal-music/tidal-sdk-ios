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
	public static func userRecommendationBlocksIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserRecommendationBlocksSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Delete from artists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userRecommendationBlocksIdRelationshipsArtistsDelete(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userRecommendationBlocksArtistsRelationshipRemoveOperationPayload: UserRecommendationBlocksArtistsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsArtistsDeleteWithRequestBuilder(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userRecommendationBlocksArtistsRelationshipRemoveOperationPayload: userRecommendationBlocksArtistsRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksArtistsMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsArtistsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> UserRecommendationBlocksArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsArtistsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Add to artists relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksArtistsMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsArtistsPost(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userRecommendationBlocksArtistsRelationshipAddOperationPayload: UserRecommendationBlocksArtistsRelationshipAddOperationPayload? = nil) async throws -> UserRecommendationBlocksArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsArtistsPostWithRequestBuilder(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userRecommendationBlocksArtistsRelationshipAddOperationPayload: userRecommendationBlocksArtistsRelationshipAddOperationPayload)
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
	public static func userRecommendationBlocksIdRelationshipsTracksDelete(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userRecommendationBlocksTracksRelationshipRemoveOperationPayload: UserRecommendationBlocksTracksRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsTracksDeleteWithRequestBuilder(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userRecommendationBlocksTracksRelationshipRemoveOperationPayload: userRecommendationBlocksTracksRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get tracks relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksTracksMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsTracksGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> UserRecommendationBlocksTracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsTracksGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Add to tracks relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksTracksMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsTracksPost(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userRecommendationBlocksTracksRelationshipAddOperationPayload: UserRecommendationBlocksTracksRelationshipAddOperationPayload? = nil) async throws -> UserRecommendationBlocksTracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsTracksPostWithRequestBuilder(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userRecommendationBlocksTracksRelationshipAddOperationPayload: userRecommendationBlocksTracksRelationshipAddOperationPayload)
		}
	}


	/**
     Delete from videos relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userRecommendationBlocksIdRelationshipsVideosDelete(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userRecommendationBlocksVideosRelationshipRemoveOperationPayload: UserRecommendationBlocksVideosRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsVideosDeleteWithRequestBuilder(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userRecommendationBlocksVideosRelationshipRemoveOperationPayload: userRecommendationBlocksVideosRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get videos relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksVideosMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsVideosGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> UserRecommendationBlocksVideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsVideosGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Add to videos relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationBlocksVideosMultiRelationshipDataDocument
     */
	public static func userRecommendationBlocksIdRelationshipsVideosPost(id: String, countryCode: String? = nil, idempotencyKey: String? = nil, userRecommendationBlocksVideosRelationshipAddOperationPayload: UserRecommendationBlocksVideosRelationshipAddOperationPayload? = nil) async throws -> UserRecommendationBlocksVideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationBlocksAPI.userRecommendationBlocksIdRelationshipsVideosPostWithRequestBuilder(id: id, countryCode: countryCode, idempotencyKey: idempotencyKey, userRecommendationBlocksVideosRelationshipAddOperationPayload: userRecommendationBlocksVideosRelationshipAddOperationPayload)
		}
	}
}
