import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - SearchResultsAPITidal

/// This is a wrapper around `SearchResultsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SearchResultsAPITidal.getResource()
/// ```
public enum SearchResultsAPITidal {
	/// Relationship: albums
	///
	/// - returns: SearchresultsMultiDataRelationshipDocument
	public static func getSearchResultsAlbumsRelationship(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> SearchresultsMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsAlbumsRelationshipWithRequestBuilder(
				query: query,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Relationship: artists
	///
	/// - returns: SearchresultsMultiDataRelationshipDocument
	public static func getSearchResultsArtistsRelationship(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> SearchresultsMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsArtistsRelationshipWithRequestBuilder(
				query: query,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Search for music metadata by a query
	///
	/// - returns: SearchresultsSingleDataDocument
	public static func getSearchResultsByQuery(
		query: String,
		countryCode: String,
		include: [String]? = nil
	) async throws -> SearchresultsSingleDataDocument {
		try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsByQueryWithRequestBuilder(query: query, countryCode: countryCode, include: include)
		}
	}

	/// Relationship: playlists
	///
	/// - returns: SearchresultsMultiDataRelationshipDocument
	public static func getSearchResultsPlaylistsRelationship(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> SearchresultsMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsPlaylistsRelationshipWithRequestBuilder(
				query: query,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Relationship: topHits
	///
	/// - returns: SearchresultsMultiDataRelationshipDocument
	public static func getSearchResultsTopHitsRelationship(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> SearchresultsMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsTopHitsRelationshipWithRequestBuilder(
				query: query,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Relationship: tracks
	///
	/// - returns: SearchresultsMultiDataRelationshipDocument
	public static func getSearchResultsTracksRelationship(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> SearchresultsMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsTracksRelationshipWithRequestBuilder(
				query: query,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}

	/// Relationship: videos
	///
	/// - returns: SearchresultsMultiDataRelationshipDocument
	public static func getSearchResultsVideosRelationship(
		query: String,
		countryCode: String,
		include: [String]? = nil,
		pageCursor: String? = nil
	) async throws -> SearchresultsMultiDataRelationshipDocument {
		try await RequestHelper.createRequest {
			SearchResultsAPI.getSearchResultsVideosRelationshipWithRequestBuilder(
				query: query,
				countryCode: countryCode,
				include: include,
				pageCursor: pageCursor
			)
		}
	}
}
