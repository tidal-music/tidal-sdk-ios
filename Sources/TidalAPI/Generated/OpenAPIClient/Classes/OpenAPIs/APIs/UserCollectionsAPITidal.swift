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
     Get single userCollection.
     
     - returns: UserCollectionsSingleDataDocument
     */
	public static func userCollectionsIdGet(id: String, locale: String, countryCode: String, include: [String]? = nil) async throws -> UserCollectionsSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdGetWithRequestBuilder(id: id, locale: locale, countryCode: countryCode, include: include)
		}
	}


	/**
     Delete from albums relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsAlbumsDelete(id: String, userCollectionAlbumsRelationshipRemoveOperationPayload: UserCollectionAlbumsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsDeleteWithRequestBuilder(id: id, userCollectionAlbumsRelationshipRemoveOperationPayload: userCollectionAlbumsRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsAlbumsMultiDataRelationshipDocument
     */
	public static func userCollectionsIdRelationshipsAlbumsGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> UserCollectionsAlbumsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Add to albums relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsAlbumsPost(id: String, countryCode: String, userCollectionAlbumsRelationshipAddOperationPayload: UserCollectionAlbumsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionAlbumsRelationshipAddOperationPayload: userCollectionAlbumsRelationshipAddOperationPayload)
		}
	}


	/**
     Delete from artists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsArtistsDelete(id: String, userCollectionArtistsRelationshipRemoveOperationPayload: UserCollectionArtistsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsDeleteWithRequestBuilder(id: id, userCollectionArtistsRelationshipRemoveOperationPayload: userCollectionArtistsRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsArtistsMultiDataRelationshipDocument
     */
	public static func userCollectionsIdRelationshipsArtistsGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> UserCollectionsArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Add to artists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsArtistsPost(id: String, countryCode: String, userCollectionArtistsRelationshipAddOperationPayload: UserCollectionArtistsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionArtistsRelationshipAddOperationPayload: userCollectionArtistsRelationshipAddOperationPayload)
		}
	}


	/**
     Delete from playlists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsPlaylistsDelete(id: String, userCollectionPlaylistsRelationshipRemoveOperationPayload: UserCollectionPlaylistsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsDeleteWithRequestBuilder(id: id, userCollectionPlaylistsRelationshipRemoveOperationPayload: userCollectionPlaylistsRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get playlists relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsPlaylistsMultiDataRelationshipDocument
     */
	public static func userCollectionsIdRelationshipsPlaylistsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> UserCollectionsPlaylistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Add to playlists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsPlaylistsPost(id: String, userCollectionPlaylistsRelationshipRemoveOperationPayload: UserCollectionPlaylistsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsPostWithRequestBuilder(id: id, userCollectionPlaylistsRelationshipRemoveOperationPayload: userCollectionPlaylistsRelationshipRemoveOperationPayload)
		}
	}
}
