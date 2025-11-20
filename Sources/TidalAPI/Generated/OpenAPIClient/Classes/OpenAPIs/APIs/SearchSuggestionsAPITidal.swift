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
	public enum ExplicitFilter_searchSuggestionsIdGet: String, CaseIterable {
		case include = "INCLUDE"
		case exclude = "EXCLUDE"

		func toSearchSuggestionsAPIEnum() -> SearchSuggestionsAPI.ExplicitFilter_searchSuggestionsIdGet {
			switch self {
			case .include: return .include
			case .exclude: return .exclude
			}
		}
	}

	/**
     Get single searchSuggestion.
     
     - returns: SearchSuggestionsSingleResourceDataDocument
     */
	public static func searchSuggestionsIdGet(id: String, explicitFilter: SearchSuggestionsAPITidal.ExplicitFilter_searchSuggestionsIdGet? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> SearchSuggestionsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SearchSuggestionsAPI.searchSuggestionsIdGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchSuggestionsAPIEnum(), countryCode: countryCode, include: include)
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
     
     - returns: SearchSuggestionsMultiRelationshipDataDocument
     */
	public static func searchSuggestionsIdRelationshipsDirectHitsGet(id: String, explicitFilter: SearchSuggestionsAPITidal.ExplicitFilter_searchSuggestionsIdRelationshipsDirectHitsGet? = nil, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchSuggestionsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchSuggestionsAPI.searchSuggestionsIdRelationshipsDirectHitsGetWithRequestBuilder(id: id, explicitFilter: explicitFilter?.toSearchSuggestionsAPIEnum(), countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}
}
