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
/// let dataDocument = try await UserRecommendationsAPI.getResource()
/// ```
public enum UserRecommendationsAPITidal {


	/**
     Get the current users recommendations
     
     - returns: UserRecommendationsSingleDataDocument
     */
	public static func getMyUserRecommendations(include: [String]? = nil) async throws -> UserRecommendationsSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.getMyUserRecommendationsWithRequestBuilder(include: include)
		}
	}


	/**
     Get recommendations for users in batch
     
     - returns: UserRecommendationsMultiDataDocument
     */
	public static func getUserRecommendationsByFilters(include: [String]? = nil, filterId: [String]? = nil) async throws -> UserRecommendationsMultiDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.getUserRecommendationsByFiltersWithRequestBuilder(include: include, filterId: filterId)
		}
	}


	/**
     Get user recommendations for user
     
     - returns: UserRecommendationsSingleDataDocument
     */
	public static func getUserRecommendationsById(id: String, include: [String]? = nil) async throws -> UserRecommendationsSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.getUserRecommendationsByIdWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Relationship: discovery mixes
     
     - returns: PlaylistsRelationshipDocument
     */
	public static func getUserRecommendationsDiscoveryMixesRelationship(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.getUserRecommendationsDiscoveryMixesRelationshipWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: my mixes
     
     - returns: PlaylistsRelationshipDocument
     */
	public static func getUserRecommendationsMyMixesRelationship(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.getUserRecommendationsMyMixesRelationshipWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: new arrivals mixes
     
     - returns: PlaylistsRelationshipDocument
     */
	public static func getUserRecommendationsNewArrivalMixesRelationship(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserRecommendationsAPI.getUserRecommendationsNewArrivalMixesRelationshipWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
