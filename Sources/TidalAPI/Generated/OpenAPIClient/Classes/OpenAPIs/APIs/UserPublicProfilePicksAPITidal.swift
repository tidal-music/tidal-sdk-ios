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
     Get all userPublicProfilePicks
     
     - returns: UserPublicProfilePicksMultiDataDocument
     */
	public static func userPublicProfilePicksGet(countryCode: String, locale: String, include: [String]? = nil, filterUserPublicProfileId: [String]? = nil, filterId: [String]? = nil) async throws -> UserPublicProfilePicksMultiDataDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilePicksAPI.userPublicProfilePicksGetWithRequestBuilder(countryCode: countryCode, locale: locale, include: include, filterUserPublicProfileId: filterUserPublicProfileId, filterId: filterId)
		}
	}


	/**
     Relationship: item(read)
     
     - returns: UserPublicProfilePicksSingletonDataRelationshipDocument
     */
	public static func userPublicProfilePicksIdRelationshipsItemGet(id: String, countryCode: String, locale: String, include: [String]? = nil) async throws -> UserPublicProfilePicksSingletonDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilePicksAPI.userPublicProfilePicksIdRelationshipsItemGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Relationship: item (create/update/delete)
     
     - returns: 
     */
	public static func userPublicProfilePicksIdRelationshipsItemPatch(updatePickRelationshipBody: UpdatePickRelationshipBody? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserPublicProfilePicksAPI.userPublicProfilePicksIdRelationshipsItemPatchWithRequestBuilder(updatePickRelationshipBody: updatePickRelationshipBody)
		}
	}


	/**
     Relationship: userPublicProfile(read)
     
     - returns: UserPublicProfilePicksSingletonDataRelationshipDocument
     */
	public static func userPublicProfilePicksIdRelationshipsUserPublicProfileGet(id: String, include: [String]? = nil) async throws -> UserPublicProfilePicksSingletonDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilePicksAPI.userPublicProfilePicksIdRelationshipsUserPublicProfileGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get current user&#39;s userPublicProfilePick data
     
     - returns: UserPublicProfilePicksMultiDataDocument
     */
	public static func userPublicProfilePicksMeGet(id: String, countryCode: String, locale: String, include: [String]? = nil) async throws -> UserPublicProfilePicksMultiDataDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilePicksAPI.userPublicProfilePicksMeGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}
}
