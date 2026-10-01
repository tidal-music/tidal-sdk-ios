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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_providerProductInfosGet: String, CaseIterable {
		case provider = "provider"
		case subject = "subject"

		func toProviderProductInfosAPIEnum() -> ProviderProductInfosAPI.IncludeLinkage_providerProductInfosGet {
			switch self {
			case .provider: return .provider
			case .subject: return .subject
			}
		}
	}

	/**
     Get multiple providerProductInfos.
     
     - returns: ProviderProductInfosMultiResourceDataDocument
     */
	public static func providerProductInfosGet(filterProviderId: [String], countryCode: String? = nil, include: [String]? = nil, filterBarcodeId: [String]? = nil, filterGrid: [String]? = nil, includeLinkage: [ProviderProductInfosAPITidal.IncludeLinkage_providerProductInfosGet]? = nil, replaceMedia: String? = nil) async throws -> ProviderProductInfosMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ProviderProductInfosAPI.providerProductInfosGetWithRequestBuilder(filterProviderId: filterProviderId, countryCode: countryCode, include: include, filterBarcodeId: filterBarcodeId, filterGrid: filterGrid, includeLinkage: includeLinkage?.compactMap { $0.toProviderProductInfosAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get provider relationship (\&quot;to-one\&quot;).
     
     - returns: ProviderProductInfosProviderSingleRelationshipDataDocument
     */
	public static func providerProductInfosIdRelationshipsProviderGet(id: String, include: [String]? = nil) async throws -> ProviderProductInfosProviderSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ProviderProductInfosAPI.providerProductInfosIdRelationshipsProviderGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: ProviderProductInfosSubjectSingleRelationshipDataDocument
     */
	public static func providerProductInfosIdRelationshipsSubjectGet(id: String, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ProviderProductInfosSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ProviderProductInfosAPI.providerProductInfosIdRelationshipsSubjectGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, replaceMedia: replaceMedia)
		}
	}
}
