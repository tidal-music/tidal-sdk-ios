import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SearchHistoryEntriesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SearchHistoryEntriesAPITidal.getResource()
/// ```
public enum SearchHistoryEntriesAPITidal {


	/**
     Delete single searchHistoryEntrie.
     
     - returns: 
     */
	public static func searchHistoryEntriesIdDelete(id: String, idempotencyKey: String? = nil) async throws {
		return try await RequestHelper.createRequest {
			SearchHistoryEntriesAPI.searchHistoryEntriesIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}
}
