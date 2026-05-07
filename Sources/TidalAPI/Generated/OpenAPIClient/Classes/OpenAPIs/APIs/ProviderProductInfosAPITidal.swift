import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ProviderProductInfosAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ProviderProductInfosAPITidal.getResource()
/// ```
public enum ProviderProductInfosAPITidal {


	/**
     Get multiple providerProductInfos.
     
     - returns: ProviderProductInfosMultiResourceDataDocument
     */
	public static func providerProductInfosGet(countryCode: String? = nil, include: [String]? = nil, filterBarcodeId: [String]? = nil, filterProviderId: [String]? = nil) async throws -> ProviderProductInfosMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ProviderProductInfosAPI.providerProductInfosGetWithRequestBuilder(countryCode: countryCode, include: include, filterBarcodeId: filterBarcodeId, filterProviderId: filterProviderId)
		}
	}


	/**
     Get provider relationship (\&quot;to-one\&quot;).
     
     - returns: ProviderProductInfosSingleRelationshipDataDocument
     */
	public static func providerProductInfosIdRelationshipsProviderGet(id: String, include: [String]? = nil) async throws -> ProviderProductInfosSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ProviderProductInfosAPI.providerProductInfosIdRelationshipsProviderGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: ProviderProductInfosSingleRelationshipDataDocument
     */
	public static func providerProductInfosIdRelationshipsSubjectGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> ProviderProductInfosSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ProviderProductInfosAPI.providerProductInfosIdRelationshipsSubjectGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}
}
