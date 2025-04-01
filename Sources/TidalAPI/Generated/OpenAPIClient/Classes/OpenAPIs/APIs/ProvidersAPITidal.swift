import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ProvidersAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ProvidersAPITidal.getResource()
/// ```
public enum ProvidersAPITidal {


	/**
     Get multiple providers.
     
     - returns: ProvidersMultiDataDocument
     */
	public static func providersGet(filterId: [String]? = nil) async throws -> ProvidersMultiDataDocument {
		return try await RequestHelper.createRequest {
			ProvidersAPI.providersGetWithRequestBuilder(filterId: filterId)
		}
	}


	/**
     Get single provider.
     
     - returns: ProvidersSingleDataDocument
     */
	public static func providersIdGet(id: String) async throws -> ProvidersSingleDataDocument {
		return try await RequestHelper.createRequest {
			ProvidersAPI.providersIdGetWithRequestBuilder(id: id)
		}
	}
}
