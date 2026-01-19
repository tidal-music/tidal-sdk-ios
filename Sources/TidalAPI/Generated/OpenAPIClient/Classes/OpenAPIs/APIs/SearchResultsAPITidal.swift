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
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
     Get single searchResult.
     
     - returns: SearchResultsSingleResourceDataDocument
     */
	public static func searchResultsIdGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdGet? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> SearchResultsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), countryCode: countryCode, include: include)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdRelationshipsAlbumsGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdRelationshipsAlbumsGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiRelationshipDataDocument
     */
	public static func searchResultsIdRelationshipsAlbumsGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdRelationshipsAlbumsGet? = nil, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> SearchResultsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsAlbumsGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdRelationshipsArtistsGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdRelationshipsArtistsGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiRelationshipDataDocument
     */
	public static func searchResultsIdRelationshipsArtistsGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdRelationshipsArtistsGet? = nil, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> SearchResultsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsArtistsGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdRelationshipsPlaylistsGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdRelationshipsPlaylistsGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
     Get playlists relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiRelationshipDataDocument
     */
	public static func searchResultsIdRelationshipsPlaylistsGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdRelationshipsPlaylistsGet? = nil, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> SearchResultsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsPlaylistsGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdRelationshipsTopHitsGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdRelationshipsTopHitsGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
     Get topHits relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiRelationshipDataDocument
     */
	public static func searchResultsIdRelationshipsTopHitsGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdRelationshipsTopHitsGet? = nil, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> SearchResultsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsTopHitsGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdRelationshipsTracksGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdRelationshipsTracksGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
     Get tracks relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiRelationshipDataDocument
     */
	public static func searchResultsIdRelationshipsTracksGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdRelationshipsTracksGet? = nil, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> SearchResultsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsTracksGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchResultsIdRelationshipsVideosGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchResultsAPIEnum() -> SearchResultsAPI.ExplicitFilter_searchResultsIdRelationshipsVideosGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
     Get videos relationship (\&quot;to-many\&quot;).
     
     - returns: SearchResultsMultiRelationshipDataDocument
     */
	public static func searchResultsIdRelationshipsVideosGet(id: String, explicitFilter: SearchResultsAPITidal.ExplicitFilter_searchResultsIdRelationshipsVideosGet? = nil, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> SearchResultsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchResultsAPI.searchResultsIdRelationshipsVideosGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchResultsAPIEnum(), pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}
}
