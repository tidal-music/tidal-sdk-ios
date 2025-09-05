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
     
     - returns: UserCollectionsSingleResourceDataDocument
     */
	public static func userCollectionsIdGet(id: String, locale: String, countryCode: String, include: [String]? = nil) async throws -> UserCollectionsSingleResourceDataDocument {
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
     
     - returns: UserCollectionsAlbumsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsAlbumsGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> UserCollectionsAlbumsMultiRelationshipDataDocument {
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
     
     - returns: UserCollectionsArtistsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsArtistsGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> UserCollectionsArtistsMultiRelationshipDataDocument {
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
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
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
     
     - returns: UserCollectionsPlaylistsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsPlaylistsGet(id: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> UserCollectionsPlaylistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include)
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


	/**
     Delete from tracks relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsTracksDelete(id: String, userCollectionTracksRelationshipRemoveOperationPayload: UserCollectionTracksRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsTracksDeleteWithRequestBuilder(id: id, userCollectionTracksRelationshipRemoveOperationPayload: userCollectionTracksRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get tracks relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsTracksMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsTracksGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> UserCollectionsTracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsTracksGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Add to tracks relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsTracksPost(id: String, countryCode: String, userCollectionTracksRelationshipAddOperationPayload: UserCollectionTracksRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsTracksPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionTracksRelationshipAddOperationPayload: userCollectionTracksRelationshipAddOperationPayload)
		}
	}


	/**
     Delete from videos relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsVideosDelete(id: String, userCollectionVideosRelationshipRemoveOperationPayload: UserCollectionVideosRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsVideosDeleteWithRequestBuilder(id: id, userCollectionVideosRelationshipRemoveOperationPayload: userCollectionVideosRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get videos relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsVideosMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsVideosGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> UserCollectionsVideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsVideosGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Add to videos relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsVideosPost(id: String, countryCode: String, userCollectionVideosRelationshipAddOperationPayload: UserCollectionVideosRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsVideosPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionVideosRelationshipAddOperationPayload: userCollectionVideosRelationshipAddOperationPayload)
		}
	}
}
