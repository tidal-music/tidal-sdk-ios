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
     Get my user profile
     
     - returns: UserPublicProfilesSingleDataDocument
     */
	public static func getMyUserPublicProfile(locale: String, include: [String]? = nil) async throws -> UserPublicProfilesSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getMyUserPublicProfileWithRequestBuilder(locale: locale, include: include)
		}
	}


	/**
     Get user public profile by id
     
     - returns: UserPublicProfilesSingleDataDocument
     */
	public static func getUserPublicProfileById(id: String, locale: String, include: [String]? = nil) async throws -> UserPublicProfilesSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getUserPublicProfileByIdWithRequestBuilder(id: id, locale: locale, include: include)
		}
	}


	/**
     Relationship: followers
     
     - returns: UsersRelationshipDocument
     */
	public static func getUserPublicProfileFollowersRelationship(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UsersRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getUserPublicProfileFollowersRelationshipWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: following
     
     - returns: UsersRelationshipDocument
     */
	public static func getUserPublicProfileFollowingRelationship(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UsersRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getUserPublicProfileFollowingRelationshipWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: picks
     
     - returns: UserPublicProfilePicksRelationshipDocument
     */
	public static func getUserPublicProfilePublicPicksRelationship(id: String, locale: String, include: [String]? = nil) async throws -> UserPublicProfilePicksRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getUserPublicProfilePublicPicksRelationshipWithRequestBuilder(id: id, locale: locale, include: include)
		}
	}


	/**
     Relationship: playlists
     
     - returns: PlaylistsRelationshipDocument
     */
	public static func getUserPublicProfilePublicPlaylistsRelationship(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getUserPublicProfilePublicPlaylistsRelationshipWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get user public profiles
     
     - returns: UserPublicProfilesMultiDataDocument
     */
	public static func getUserPublicProfilesByFilters(locale: String, include: [String]? = nil, filterId: [String]? = nil) async throws -> UserPublicProfilesMultiDataDocument {
		return try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getUserPublicProfilesByFiltersWithRequestBuilder(locale: locale, include: include, filterId: filterId)
		}
	}
}
