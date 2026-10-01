import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SearchSuggestionsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SearchSuggestionsAPITidal.getResource()
/// ```
public enum SearchSuggestionsAPITidal {


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchSuggestionsGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchSuggestionsAPIEnum() -> SearchSuggestionsAPI.ExplicitFilter_searchSuggestionsGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_searchSuggestionsGet: String, CaseIterable {
		case directhits = "directHits"
		case history = "history"

		func toSearchSuggestionsAPIEnum() -> SearchSuggestionsAPI.IncludeLinkage_searchSuggestionsGet {
			switch self {
			case .directhits: return .directhits
			case .history: return .history
			}
		}
	}

	/**
     Get search suggestions by query.
     
     - returns: SearchSuggestionsMultiResourceDataDocument
     */
	public static func searchSuggestionsGet(filterQuery: String, explicitFilter: SearchSuggestionsAPITidal.ExplicitFilter_searchSuggestionsGet? = nil, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [SearchSuggestionsAPITidal.IncludeLinkage_searchSuggestionsGet]? = nil, replaceMedia: String? = nil) async throws -> SearchSuggestionsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			SearchSuggestionsAPI.searchSuggestionsGetWithRequestBuilder(filterQuery: filterQuery, explicitFilter: explicitFilter?.toSearchSuggestionsAPIEnum(), countryCode: countryCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toSearchSuggestionsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchSuggestionsIdRelationshipsDirectHitsGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchSuggestionsAPIEnum() -> SearchSuggestionsAPI.ExplicitFilter_searchSuggestionsIdRelationshipsDirectHitsGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
     Get directHits relationship (\&quot;to-many\&quot;).
     
     - returns: SearchSuggestionsDirectHitsMultiRelationshipDataDocument
     */
	public static func searchSuggestionsIdRelationshipsDirectHitsGet(id: String, explicitFilter: SearchSuggestionsAPITidal.ExplicitFilter_searchSuggestionsIdRelationshipsDirectHitsGet? = nil, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> SearchSuggestionsDirectHitsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchSuggestionsAPI.searchSuggestionsIdRelationshipsDirectHitsGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchSuggestionsAPIEnum(), countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter explicitFilter
	 */
	public enum ExplicitFilter_searchSuggestionsIdRelationshipsHistoryGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchSuggestionsAPIEnum() -> SearchSuggestionsAPI.ExplicitFilter_searchSuggestionsIdRelationshipsHistoryGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
     Get history relationship (\&quot;to-many\&quot;).
     
     - returns: SearchSuggestionsHistoryMultiRelationshipDataDocument
     */
	public static func searchSuggestionsIdRelationshipsHistoryGet(id: String, explicitFilter: SearchSuggestionsAPITidal.ExplicitFilter_searchSuggestionsIdRelationshipsHistoryGet? = nil, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchSuggestionsHistoryMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchSuggestionsAPI.searchSuggestionsIdRelationshipsHistoryGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchSuggestionsAPIEnum(), countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}
}
