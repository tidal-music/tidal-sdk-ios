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
     Get multiple providerOwners.
     
     - returns: ProviderOwnersMultiResourceDataDocument
     */
	public static func providerOwnersGet(include: [String]? = nil, filterOwnersId: [String]? = nil) async throws -> ProviderOwnersMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ProviderOwnersAPI.providerOwnersGetWithRequestBuilder(include: include, filterOwnersId: filterOwnersId)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ProviderOwnersMultiRelationshipDataDocument
     */
	public static func providerOwnersIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ProviderOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ProviderOwnersAPI.providerOwnersIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get provider relationship (\&quot;to-one\&quot;).
     
     - returns: ProviderOwnersSingleRelationshipDataDocument
     */
	public static func providerOwnersIdRelationshipsProviderGet(id: String, include: [String]? = nil) async throws -> ProviderOwnersSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ProviderOwnersAPI.providerOwnersIdRelationshipsProviderGetWithRequestBuilder(id: id, include: include)
		}
	}
}
