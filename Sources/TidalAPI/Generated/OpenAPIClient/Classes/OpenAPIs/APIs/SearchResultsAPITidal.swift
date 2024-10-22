import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SearchResultsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SearchResultsAPI.getResource()
/// ```
public enum SearchResultsAPITidal {


	/**
     Relationship: albums
     
     - returns: AlbumsRelationshipDocument
     */
	public static func getSearchResultsAlbumsRelationship(query: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumsRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsAlbumsRelationshipWithRequestBuilder(query: query, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: artists
     
     - returns: ArtistsRelationshipDocument
     */
	public static func getSearchResultsArtistsRelationship(query: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsArtistsRelationshipWithRequestBuilder(query: query, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Search for music metadata by a query
     
     - returns: SearchResultsSingleDataDocument
     */
	public static func getSearchResultsByQuery(query: String, countryCode: String, include: [String]? = nil) async throws -> SearchResultsSingleDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsByQueryWithRequestBuilder(query: query, countryCode: countryCode, include: include)
		}
	}


	/**
     Relationship: playlists
     
     - returns: PlaylistsRelationshipDocument
     */
	public static func getSearchResultsPlaylistsRelationship(query: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsPlaylistsRelationshipWithRequestBuilder(query: query, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: topHits
     
     - returns: SearchResultsTopHitsRelationshipDocument
     */
	public static func getSearchResultsTopHitsRelationship(query: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchResultsTopHitsRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsTopHitsRelationshipWithRequestBuilder(query: query, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: tracks
     
     - returns: TracksRelationshipsDocument
     */
	public static func getSearchResultsTracksRelationship(query: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksRelationshipsDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsTracksRelationshipWithRequestBuilder(query: query, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: videos
     
     - returns: VideosRelationshipsDocument
     */
	public static func getSearchResultsVideosRelationship(query: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> VideosRelationshipsDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsVideosRelationshipWithRequestBuilder(query: query, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}
}
