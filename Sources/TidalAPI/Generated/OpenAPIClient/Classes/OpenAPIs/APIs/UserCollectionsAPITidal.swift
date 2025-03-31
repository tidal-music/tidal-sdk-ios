import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserCollectionsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserCollectionsAPITidal.getResource()
/// ```
public enum UserCollectionsAPITidal {


	/**
     Get all userCollections
     
     - returns: UserCollectionsMultiDataDocument
     */
	public static func userCollectionsGet(countryCode: String, locale: String, include: [String]? = nil, filterId: [String]? = nil) async throws -> UserCollectionsMultiDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsGetWithRequestBuilder(countryCode: countryCode, locale: locale, include: include, filterId: filterId)
		}
	}


	/**
     Get single userCollection
     
     - returns: UserCollectionsSingleDataDocument
     */
	public static func userCollectionsIdGet(id: String, countryCode: String, locale: String, include: [String]? = nil) async throws -> UserCollectionsSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Relationship: albums (remove)
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsAlbumsDelete(updateMyCollectionRelationshipPayload: UpdateMyCollectionRelationshipPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsDeleteWithRequestBuilder(updateMyCollectionRelationshipPayload: updateMyCollectionRelationshipPayload)
		}
	}


	/**
     Relationship: albums
     
     - returns: UserCollectionsMultiDataRelationshipDocument
     */
	public static func userCollectionsIdRelationshipsAlbumsGet(id: String, countryCode: String, locale: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: albums (add)
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsAlbumsPost(countryCode: String, updateMyCollectionRelationshipPayload: UpdateMyCollectionRelationshipPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsPostWithRequestBuilder(countryCode: countryCode, updateMyCollectionRelationshipPayload: updateMyCollectionRelationshipPayload)
		}
	}


	/**
     Relationship: artists (remove)
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsArtistsDelete(updateMyCollectionRelationshipPayload: UpdateMyCollectionRelationshipPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsDeleteWithRequestBuilder(updateMyCollectionRelationshipPayload: updateMyCollectionRelationshipPayload)
		}
	}


	/**
     Relationship: artists
     
     - returns: UserCollectionsMultiDataRelationshipDocument
     */
	public static func userCollectionsIdRelationshipsArtistsGet(id: String, countryCode: String, locale: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: artists (add)
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsArtistsPost(countryCode: String, updateMyCollectionRelationshipPayload: UpdateMyCollectionRelationshipPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsPostWithRequestBuilder(countryCode: countryCode, updateMyCollectionRelationshipPayload: updateMyCollectionRelationshipPayload)
		}
	}


	/**
     Relationship: playlists (remove)
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsPlaylistsDelete(updateMyCollectionRelationshipPayload: UpdateMyCollectionRelationshipPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsDeleteWithRequestBuilder(updateMyCollectionRelationshipPayload: updateMyCollectionRelationshipPayload)
		}
	}


	/**
     Relationship: playlists
     
     - returns: UserCollectionsMultiDataRelationshipDocument
     */
	public static func userCollectionsIdRelationshipsPlaylistsGet(id: String, countryCode: String, locale: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: playlists (add)
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsPlaylistsPost(countryCode: String, updateMyCollectionRelationshipPayload: UpdateMyCollectionRelationshipPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsPostWithRequestBuilder(countryCode: countryCode, updateMyCollectionRelationshipPayload: updateMyCollectionRelationshipPayload)
		}
	}


	/**
     Get current user&#39;s userCollection data
     
     - returns: UserCollectionsSingleDataDocument
     */
	public static func userCollectionsMeGet(countryCode: String, locale: String, include: [String]? = nil) async throws -> UserCollectionsSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsMeGetWithRequestBuilder(countryCode: countryCode, locale: locale, include: include)
		}
	}
}
