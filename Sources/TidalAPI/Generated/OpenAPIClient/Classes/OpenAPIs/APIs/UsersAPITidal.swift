import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - UsersAPITidal

/// This is a wrapper around `UsersAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UsersAPITidal.getResource()
/// ```
public enum UsersAPITidal {
	/// Get the current user
	///
	/// - returns: UsersSingleDataDocument
	public static func getMyUser(include: [String]? = nil) async throws -> UsersSingleDataDocument {
		try await RequestHelper.createRequest {
			UsersAPI.getMyUserWithRequestBuilder(include: include)
		}
	}

	/// Get a single user by id
	///
	/// - returns: UsersSingleDataDocument
	public static func getUserById(id: String, include: [String]? = nil) async throws -> UsersSingleDataDocument {
		try await RequestHelper.createRequest {
			UsersAPI.getUserByIdWithRequestBuilder(id: id, include: include)
		}
	}

	/// Relationship: entitlements
	///
	/// - returns: UsersSingletonDataRelationshipDocument
	public static func getUserEntitlementsRelationship(
		id: String,
		include: [String]? = nil
	) async throws -> UsersSingletonDataRelationshipDocument {
		try await RequestHelper.createRequest {
			UsersAPI.getUserEntitlementsRelationshipWithRequestBuilder(id: id, include: include)
		}
	}

	/// Relationship: public profile
	///
	/// - returns: UsersSingletonDataRelationshipDocument
	public static func getUserPublicProfileRelationship(
		id: String,
		locale: String,
		include: [String]? = nil
	) async throws -> UsersSingletonDataRelationshipDocument {
		try await RequestHelper.createRequest {
			UsersAPI.getUserPublicProfileRelationshipWithRequestBuilder(id: id, locale: locale, include: include)
		}
	}

	/// Relationship: user recommendations
	///
	/// - returns: UsersSingletonDataRelationshipDocument
	public static func getUserRecommendationsRelationship(
		id: String,
		include: [String]? = nil
	) async throws -> UsersSingletonDataRelationshipDocument {
		try await RequestHelper.createRequest {
			UsersAPI.getUserRecommendationsRelationshipWithRequestBuilder(id: id, include: include)
		}
	}

	/// Get multiple users by id
	///
	/// - returns: UsersMultiDataDocument
	public static func getUsersByFilters(
		include: [String]? = nil,
		filterId: [String]? = nil
	) async throws -> UsersMultiDataDocument {
		try await RequestHelper.createRequest {
			UsersAPI.getUsersByFiltersWithRequestBuilder(include: include, filterId: filterId)
		}
	}
}
