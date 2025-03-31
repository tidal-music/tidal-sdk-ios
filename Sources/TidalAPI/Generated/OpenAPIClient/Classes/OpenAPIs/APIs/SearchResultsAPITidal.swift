import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SearchresultsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SearchresultsAPITidal.getResource()
/// ```
public enum SearchresultsAPITidal {


	/**
     Get single search result
     
     - returns: SearchresultsSingleDataDocument
     */
	public static func searchresultsIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> SearchresultsSingleDataDocument {
		return try await RequestHelper.createRequest {
			SearchresultsAPI.searchresultsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Relationship: albums
     
     - returns: SearchresultsMultiDataRelationshipDocument
     */
	public static func searchresultsIdRelationshipsAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchresultsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchresultsAPI.searchresultsIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: artists
     
     - returns: SearchresultsMultiDataRelationshipDocument
     */
	public static func searchresultsIdRelationshipsArtistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchresultsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchresultsAPI.searchresultsIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: playlists
     
     - returns: SearchresultsMultiDataRelationshipDocument
     */
	public static func searchresultsIdRelationshipsPlaylistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchresultsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchresultsAPI.searchresultsIdRelationshipsPlaylistsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: topHits
     
     - returns: SearchresultsMultiDataRelationshipDocument
     */
	public static func searchresultsIdRelationshipsTopHitsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchresultsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchresultsAPI.searchresultsIdRelationshipsTopHitsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: tracks
     
     - returns: SearchresultsMultiDataRelationshipDocument
     */
	public static func searchresultsIdRelationshipsTracksGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchresultsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchresultsAPI.searchresultsIdRelationshipsTracksGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: videos
     
     - returns: SearchresultsMultiDataRelationshipDocument
     */
	public static func searchresultsIdRelationshipsVideosGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchresultsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchresultsAPI.searchresultsIdRelationshipsVideosGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}
}
