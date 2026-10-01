import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ProviderOwnersAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ProviderOwnersAPITidal.getResource()
/// ```
public enum ProviderOwnersAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_providerOwnersGet: String, CaseIterable {
		case owners = "owners"
		case provider = "provider"

		func toProviderOwnersAPIEnum() -> ProviderOwnersAPI.IncludeLinkage_providerOwnersGet {
			switch self {
			case .owners: return .owners
			case .provider: return .provider
			}
		}
	}

	/**
     Get multiple providerOwners.
     
     - returns: ProviderOwnersMultiResourceDataDocument
     */
	public static func providerOwnersGet(filterOwnersId: [String], include: [String]? = nil, includeLinkage: [ProviderOwnersAPITidal.IncludeLinkage_providerOwnersGet]? = nil) async throws -> ProviderOwnersMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ProviderOwnersAPI.providerOwnersGetWithRequestBuilder(filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage?.compactMap { $0.toProviderOwnersAPIEnum() })
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ProviderOwnersOwnersMultiRelationshipDataDocument
     */
	public static func providerOwnersIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ProviderOwnersOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ProviderOwnersAPI.providerOwnersIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get provider relationship (\&quot;to-one\&quot;).
     
     - returns: ProviderOwnersProviderSingleRelationshipDataDocument
     */
	public static func providerOwnersIdRelationshipsProviderGet(id: String, include: [String]? = nil) async throws -> ProviderOwnersProviderSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ProviderOwnersAPI.providerOwnersIdRelationshipsProviderGetWithRequestBuilder(id: id, include: include)
		}
	}
}
