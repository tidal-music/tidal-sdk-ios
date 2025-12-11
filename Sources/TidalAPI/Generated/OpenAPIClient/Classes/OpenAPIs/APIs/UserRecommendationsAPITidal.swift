import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserRecommendationsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserRecommendationsAPITidal.getResource()
/// ```
public enum UserRecommendationsAPITidal {


	/**
     Get single userRecommendation.
     
     - returns: UserRecommendationsSingleResourceDataDocument
     */
	public static func userRecommendationsIdGet(id: String, countryCode: String, locale: String? = nil, include: [String]? = nil) async throws -> UserRecommendationsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.userRecommendationsIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Get discoveryMixes relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationsMultiRelationshipDataDocument
     */
	public static func userRecommendationsIdRelationshipsDiscoveryMixesGet(id: String, countryCode: String, pageCursor: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserRecommendationsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.userRecommendationsIdRelationshipsDiscoveryMixesGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, locale: locale, include: include)
		}
	}


	/**
     Get myMixes relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationsMultiRelationshipDataDocument
     */
	public static func userRecommendationsIdRelationshipsMyMixesGet(id: String, countryCode: String, pageCursor: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserRecommendationsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.userRecommendationsIdRelationshipsMyMixesGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, locale: locale, include: include)
		}
	}


	/**
     Get newArrivalMixes relationship (\&quot;to-many\&quot;).
     
     - returns: UserRecommendationsMultiRelationshipDataDocument
     */
	public static func userRecommendationsIdRelationshipsNewArrivalMixesGet(id: String, countryCode: String, pageCursor: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserRecommendationsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.userRecommendationsIdRelationshipsNewArrivalMixesGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, locale: locale, include: include)
		}
	}
}
