import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserPublicProfilesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserPublicProfilesAPITidal.getResource()
/// ```
public enum UserPublicProfilesAPITidal {


	/**
     Get all userPublicProfiles
     
     - returns: UserPublicProfilesMultiDataDocument
     */
	public static func userPublicProfilesGet(countryCode: String, include: [String]? = nil, filterId: [String]? = nil) async throws -> UserPublicProfilesMultiDataDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.userPublicProfilesGetWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId)
		}
	}


	/**
     Get single userPublicProfile
     
     - returns: UserPublicProfilesSingleDataDocument
     */
	public static func userPublicProfilesIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> UserPublicProfilesSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.userPublicProfilesIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Update single userPublicProfile
     
     - returns: 
     */
	public static func userPublicProfilesIdPatch(updateUserProfileBody: UpdateUserProfileBody? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.userPublicProfilesIdPatchWithRequestBuilder(updateUserProfileBody: updateUserProfileBody)
		}
	}


	/**
     Relationship: followers
     
     - returns: UserPublicProfilesMultiDataRelationshipDocument
     */
	public static func userPublicProfilesIdRelationshipsFollowersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserPublicProfilesMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.userPublicProfilesIdRelationshipsFollowersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: following
     
     - returns: UserPublicProfilesMultiDataRelationshipDocument
     */
	public static func userPublicProfilesIdRelationshipsFollowingGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserPublicProfilesMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.userPublicProfilesIdRelationshipsFollowingGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: publicPicks
     
     - returns: UserPublicProfilesMultiDataRelationshipDocument
     */
	public static func userPublicProfilesIdRelationshipsPublicPicksGet(id: String, countryCode: String, locale: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserPublicProfilesMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.userPublicProfilesIdRelationshipsPublicPicksGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: publicPlaylists
     
     - returns: UserPublicProfilesMultiDataRelationshipDocument
     */
	public static func userPublicProfilesIdRelationshipsPublicPlaylistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserPublicProfilesMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.userPublicProfilesIdRelationshipsPublicPlaylistsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get current user&#39;s userPublicProfile data
     
     - returns: UserPublicProfilesSingleDataDocument
     */
	public static func userPublicProfilesMeGet(countryCode: String, include: [String]? = nil) async throws -> UserPublicProfilesSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.userPublicProfilesMeGetWithRequestBuilder(countryCode: countryCode, include: include)
		}
	}
}
