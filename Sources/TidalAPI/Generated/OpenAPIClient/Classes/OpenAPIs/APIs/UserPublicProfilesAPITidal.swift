import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UserPublicProfilesAPITidal

/// This is a wrapper around `UserPublicProfilesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserPublicProfilesAPITidal.getResource()
/// ```
public enum UserPublicProfilesAPITidal {
	/// Get my user profile
	///
	/// - returns: UserPublicProfilesSingleDataDocument
	public static func getMyUserPublicProfile(
		locale: String,
		include: [String]? = nil
	) async throws -> UserPublicProfilesSingleDataDocument {
		try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getMyUserPublicProfileWithRequestBuilder(locale: locale, include: include)
		}
	}

	/// Get user public profile by id
	///
	/// - returns: UserPublicProfilesSingleDataDocument
	public static func getUserPublicProfileById(
		id: String,
		locale: String,
		include: [String]? = nil
	) async throws -> UserPublicProfilesSingleDataDocument {
		try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getUserPublicProfileByIdWithRequestBuilder(id: id, locale: locale, include: include)
		}
	}

	/// Relationship: followers
	///
	/// - returns: UserPublicProfilesMultiDataRelationshipDocument
	public static func getUserPublicProfileFollowersRelationship(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> UserPublicProfilesMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getUserPublicProfileFollowersRelationshipWithRequestBuilder(
				id: id,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Relationship: following
	///
	/// - returns: UserPublicProfilesMultiDataRelationshipDocument
	public static func getUserPublicProfileFollowingRelationship(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> UserPublicProfilesMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getUserPublicProfileFollowingRelationshipWithRequestBuilder(
				id: id,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Relationship: picks
	///
	/// - returns: UserPublicProfilesMultiDataRelationshipDocument
	public static func getUserPublicProfilePublicPicksRelationship(
		id: String,
		locale: String,
		include: [String]? = nil
	) async throws -> UserPublicProfilesMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getUserPublicProfilePublicPicksRelationshipWithRequestBuilder(id: id, locale: locale, include: include)
		}
	}

	/// Relationship: playlists
	///
	/// - returns: UserPublicProfilesMultiDataRelationshipDocument
	public static func getUserPublicProfilePublicPlaylistsRelationship(
		id: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> UserPublicProfilesMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getUserPublicProfilePublicPlaylistsRelationshipWithRequestBuilder(
				id: id,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Get user public profiles
	///
	/// - returns: UserPublicProfilesMultiDataDocument
	public static func getUserPublicProfilesByFilters(
		locale: String,
		include: [String]? = nil,
		filterId: [String]? = nil
	) async throws -> UserPublicProfilesMultiDataDocument {
		try await RequestHelper.createRequest {
			UserPublicProfilesAPI.getUserPublicProfilesByFiltersWithRequestBuilder(locale: locale, include: include, filterId: filterId)
		}
	}

	/// Update user public profile
	///
	/// - returns: AnyCodable
	public static func updateMyUserProfile(
		id: String,
		updateUserProfileBody: UpdateUserProfileBody,
		include: [String]? = nil
	) async throws -> AnyCodable {
		try await RequestHelper.createRequest {
			UserPublicProfilesAPI.updateMyUserProfileWithRequestBuilder(
				id: id,
				updateUserProfileBody: updateUserProfileBody,
				include: include
			)
		}
	}
}
