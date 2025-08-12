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
     
     - returns: ProvidersMultiResourceDataDocument
     */
	public static func providersGet(filterId: [String]? = nil) async throws -> ProvidersMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ProvidersAPI.providersGetWithRequestBuilder(filterId: filterId)
		}
	}

	/**
     Get single provider.
     
     - returns: ProvidersSingleResourceDataDocument
     */
	public static func providersIdGet(id: String) async throws -> ProvidersSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ProvidersAPI.providersIdGetWithRequestBuilder(id: id)
		}
	}
}
