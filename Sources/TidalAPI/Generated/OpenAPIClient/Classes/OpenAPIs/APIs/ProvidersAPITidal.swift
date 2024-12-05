import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ProvidersAPITidal

/// This is a wrapper around `ProvidersAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ProvidersAPITidal.getResource()
/// ```
public enum ProvidersAPITidal {
	/// Get single provider
	///
	/// - returns: ProvidersSingleDataDocument
	public static func getProviderById(id: String, include: [String]? = nil) async throws -> ProvidersSingleDataDocument {
		try await RequestHelper.createRequest {
			ProvidersAPI.getProviderByIdWithRequestBuilder(id: id, include: include)
		}
	}

	/// Get multiple providers
	///
	/// - returns: ProvidersMultiDataDocument
	public static func getProvidersByFilters(
		include: [String]? = nil,
		filterId: [String]? = nil
	) async throws -> ProvidersMultiDataDocument {
		try await RequestHelper.createRequest {
			ProvidersAPI.getProvidersByFiltersWithRequestBuilder(include: include, filterId: filterId)
		}
	}
}
