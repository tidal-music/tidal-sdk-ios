import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserPublicProfilePicksAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserPublicProfilePicksAPITidal.getResource()
/// ```
public enum UserPublicProfilePicksAPITidal {


	/**
     Get my picks
     
     - returns: UserPublicProfilePicksMultiDataDocument
     */
	public static func getMyUserPublicProfilePicks(locale: String, include: [String]? = nil) async throws -> UserPublicProfilePicksMultiDataDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilePicksAPI.getMyUserPublicProfilePicksWithRequestBuilder(locale: locale, include: include)
		}
	}


	/**
     Relationship: item (read)
     
     - returns: UserPublicProfilePicksSingletonDataRelationshipDocument
     */
	public static func getUserPublicProfilePickItemRelationship(id: String, locale: String, include: [String]? = nil) async throws -> UserPublicProfilePicksSingletonDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilePicksAPI.getUserPublicProfilePickItemRelationshipWithRequestBuilder(id: id, locale: locale, include: include)
		}
	}


	/**
     Relationship: user public profile
     
     - returns: UserPublicProfilePicksSingletonDataRelationshipDocument
     */
	public static func getUserPublicProfilePickUserPublicProfileRelationship(id: String, include: [String]? = nil) async throws -> UserPublicProfilePicksSingletonDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilePicksAPI.getUserPublicProfilePickUserPublicProfileRelationshipWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get picks
     
     - returns: UserPublicProfilePicksMultiDataDocument
     */
	public static func getUserPublicProfilePicksByFilters(locale: String, include: [String]? = nil, filterId: [String]? = nil, filterUserPublicProfileId: [String]? = nil) async throws -> UserPublicProfilePicksMultiDataDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilePicksAPI.getUserPublicProfilePicksByFiltersWithRequestBuilder(locale: locale, include: include, filterId: filterId, filterUserPublicProfileId: filterUserPublicProfileId)
		}
	}


	/**
     Relationship: item (update)
     
     - returns: AnyCodable
     */
	public static func setUserPublicProfilePickItemRelationship(id: String, updatePickRelationshipBody: UpdatePickRelationshipBody, include: [String]? = nil) async throws -> AnyCodable {
		return try await RequestHelper.createRequest {
			UserPublicProfilePicksAPI.setUserPublicProfilePickItemRelationshipWithRequestBuilder(id: id, updatePickRelationshipBody: updatePickRelationshipBody, include: include)
		}
	}
}
