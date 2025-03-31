import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UsersAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UsersAPITidal.getResource()
/// ```
public enum UsersAPITidal {


	/**
     Get all users
     
     - returns: UsersMultiDataDocument
     */
	public static func usersGet(include: [String]? = nil, filterId: [String]? = nil) async throws -> UsersMultiDataDocument {
		return try await RequestHelper.createRequest {
			UsersAPI.usersGetWithRequestBuilder(include: include, filterId: filterId)
		}
	}


	/**
     Get single user
     
     - returns: UsersSingleDataDocument
     */
	public static func usersIdGet(id: String, include: [String]? = nil) async throws -> UsersSingleDataDocument {
		return try await RequestHelper.createRequest {
			UsersAPI.usersIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Relationship: entitlements(read)
     
     - returns: UsersSingletonDataRelationshipDocument
     */
	public static func usersIdRelationshipsEntitlementsGet(id: String, include: [String]? = nil) async throws -> UsersSingletonDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UsersAPI.usersIdRelationshipsEntitlementsGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Relationship: publicProfile(read)
     
     - returns: UsersSingletonDataRelationshipDocument
     */
	public static func usersIdRelationshipsPublicProfileGet(id: String, locale: String, include: [String]? = nil) async throws -> UsersSingletonDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UsersAPI.usersIdRelationshipsPublicProfileGetWithRequestBuilder(id: id, locale: locale, include: include)
		}
	}


	/**
     Relationship: recommendations(read)
     
     - returns: UsersSingletonDataRelationshipDocument
     */
	public static func usersIdRelationshipsRecommendationsGet(id: String, include: [String]? = nil) async throws -> UsersSingletonDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UsersAPI.usersIdRelationshipsRecommendationsGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get current user&#39;s user data
     
     - returns: UsersSingleDataDocument
     */
	public static func usersMeGet(include: [String]? = nil) async throws -> UsersSingleDataDocument {
		return try await RequestHelper.createRequest {
			UsersAPI.usersMeGetWithRequestBuilder(include: include)
		}
	}
}
