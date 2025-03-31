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
     Get all userRecommendations
     
     - returns: UserRecommendationsMultiDataDocument
     */
	public static func userRecommendationsGet(include: [String]? = nil, filterId: [String]? = nil) async throws -> UserRecommendationsMultiDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.userRecommendationsGetWithRequestBuilder(include: include, filterId: filterId)
		}
	}


	/**
     Get single userRecommendation
     
     - returns: UserRecommendationsSingleDataDocument
     */
	public static func userRecommendationsIdGet(id: String, include: [String]? = nil) async throws -> UserRecommendationsSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.userRecommendationsIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Relationship: discoveryMixes
     
     - returns: UserRecommendationsMultiDataRelationshipDocument
     */
	public static func userRecommendationsIdRelationshipsDiscoveryMixesGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserRecommendationsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.userRecommendationsIdRelationshipsDiscoveryMixesGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: myMixes
     
     - returns: UserRecommendationsMultiDataRelationshipDocument
     */
	public static func userRecommendationsIdRelationshipsMyMixesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserRecommendationsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.userRecommendationsIdRelationshipsMyMixesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: newArrivalMixes
     
     - returns: UserRecommendationsMultiDataRelationshipDocument
     */
	public static func userRecommendationsIdRelationshipsNewArrivalMixesGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserRecommendationsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.userRecommendationsIdRelationshipsNewArrivalMixesGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get current user&#39;s userRecommendation data
     
     - returns: UserRecommendationsSingleDataDocument
     */
	public static func userRecommendationsMeGet(include: [String]? = nil) async throws -> UserRecommendationsSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.userRecommendationsMeGetWithRequestBuilder(include: include)
		}
	}
}
