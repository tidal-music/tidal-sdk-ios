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
     Get single searchSuggestion.
     
     - returns: SearchSuggestionsSingleResourceDataDocument
     */
	public static func searchSuggestionsIdGet(id: String, countryCode: String, explicitFilter: String? = nil, include: [String]? = nil) async throws -> SearchSuggestionsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SearchSuggestionsAPI.searchSuggestionsIdGetWithRequestBuilder(id: id, countryCode: countryCode, explicitFilter: explicitFilter, include: include)
		}
	}


	/**
     Get directHits relationship (\&quot;to-many\&quot;).
     
     - returns: SearchSuggestionsMultiRelationshipDataDocument
     */
	public static func searchSuggestionsIdRelationshipsDirectHitsGet(id: String, countryCode: String, explicitFilter: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchSuggestionsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SearchSuggestionsAPI.searchSuggestionsIdRelationshipsDirectHitsGetWithRequestBuilder(id: id, countryCode: countryCode, explicitFilter: explicitFilter, include: include, pageCursor: pageCursor)
		}
	}
}
