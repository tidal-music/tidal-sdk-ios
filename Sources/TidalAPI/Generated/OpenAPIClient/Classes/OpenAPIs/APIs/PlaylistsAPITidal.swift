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
     Get current user&#39;s playlists
     
     - returns: PlaylistsMultiDataDocument
     */
	public static func getMyPlaylists(include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsMultiDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.getMyPlaylistsWithRequestBuilder(include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get single playlist
     
     - returns: PlaylistsSingleDataDocument
     */
	public static func getPlaylistById(countryCode: String, id: String, include: [String]? = nil) async throws -> PlaylistsSingleDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.getPlaylistByIdWithRequestBuilder(countryCode: countryCode, id: id, include: include)
		}
	}


	/**
     Relationship: items
     
     - returns: PlaylistsMultiDataRelationshipDocument
     */
	public static func getPlaylistItemsRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.getPlaylistItemsRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: owner
     
     - returns: PlaylistsMultiDataRelationshipDocument
     */
	public static func getPlaylistOwnersRelationship(id: String, countryCode: String, include: [String]? = nil) async throws -> PlaylistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.getPlaylistOwnersRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Get multiple playlists
     
     - returns: PlaylistsMultiDataDocument
     */
	public static func getPlaylistsByFilters(countryCode: String, include: [String]? = nil, filterId: [String]? = nil) async throws -> PlaylistsMultiDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.getPlaylistsByFiltersWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId)
		}
	}
}
