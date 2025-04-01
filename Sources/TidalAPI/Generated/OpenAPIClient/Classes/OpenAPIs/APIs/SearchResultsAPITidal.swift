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
/// let dataDocument = try await SearchResultsAPITidal.getResource()
/// ```
public enum SearchResultsAPITidal {


	/**
     Get single searchResult.
     
     - returns: SearchResultsSingleDataDocument
     */
	public static func searchResultsIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> SearchResultsSingleDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiDataRelationshipDocument
     */
	public static func searchResultsIdRelationshipsAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchResultsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiDataRelationshipDocument
     */
	public static func searchResultsIdRelationshipsArtistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchResultsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get playlists relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiDataRelationshipDocument
     */
	public static func searchResultsIdRelationshipsPlaylistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchResultsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsPlaylistsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get topHits relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiDataRelationshipDocument
     */
	public static func searchResultsIdRelationshipsTopHitsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchResultsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsTopHitsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get tracks relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiDataRelationshipDocument
     */
	public static func searchResultsIdRelationshipsTracksGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchResultsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsTracksGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get videos relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiDataRelationshipDocument
     */
	public static func searchResultsIdRelationshipsVideosGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchResultsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsVideosGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}
}
