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
     
     - returns: SearchSuggestionsSingleDataDocument
     */
	public static func searchSuggestionsIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> SearchSuggestionsSingleDataDocument {
		return try await RequestHelper.createRequest {
			SearchSuggestionsAPI.searchSuggestionsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Get directHits relationship (\&quot;to-many\&quot;).
     
     - returns: SearchSuggestionsMultiDataRelationshipDocument
     */
	public static func searchSuggestionsIdRelationshipsDirectHitsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SearchSuggestionsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			SearchSuggestionsAPI.searchSuggestionsIdRelationshipsDirectHitsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}
}
