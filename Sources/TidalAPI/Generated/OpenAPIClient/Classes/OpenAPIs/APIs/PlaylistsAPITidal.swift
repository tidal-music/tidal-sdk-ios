import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `PlaylistsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await PlaylistsAPITidal.getResource()
/// ```
public enum PlaylistsAPITidal {


	/**
     Get all playlists
     
     - returns: PlaylistsMultiDataDocument
     */
	public static func playlistsGet(countryCode: String? = nil, include: [String]? = nil, filterId: [String]? = nil) async throws -> PlaylistsMultiDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsGetWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId)
		}
	}


	/**
     Delete single playlist
     
     - returns: 
     */
	public static func playlistsIdDelete(id: String) async throws {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdDeleteWithRequestBuilder(id: id)
		}
	}


	/**
     Get single playlist
     
     - returns: PlaylistsSingleDataDocument
     */
	public static func playlistsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> PlaylistsSingleDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Update single playlist
     
     - returns: 
     */
	public static func playlistsIdPatch(id: String, updatePlaylistBody: UpdatePlaylistBody? = nil) async throws {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdPatchWithRequestBuilder(id: id, updatePlaylistBody: updatePlaylistBody)
		}
	}


	/**
     Relationship: items
     
     - returns: PlaylistsMultiDataRelationshipDocument
     */
	public static func playlistsIdRelationshipsItemsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdRelationshipsItemsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: owners
     
     - returns: PlaylistsMultiDataRelationshipDocument
     */
	public static func playlistsIdRelationshipsOwnersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdRelationshipsOwnersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get current user&#39;s playlist data
     
     - returns: PlaylistsMultiDataDocument
     */
	public static func playlistsMeGet(include: [String]? = nil) async throws -> PlaylistsMultiDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsMeGetWithRequestBuilder(include: include)
		}
	}


	/**
     Create single playlist
     
     - returns: PlaylistsSingleDataDocument
     */
	public static func playlistsPost(createPlaylistBody: CreatePlaylistBody? = nil) async throws -> PlaylistsSingleDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsPostWithRequestBuilder(createPlaylistBody: createPlaylistBody)
		}
	}
}
