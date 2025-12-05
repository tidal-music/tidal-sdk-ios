import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserEntitlementsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserEntitlementsAPITidal.getResource()
/// ```
public enum UserEntitlementsAPITidal {


	/**
     Get single userEntitlement.
     
     - returns: UserEntitlementsSingleResourceDataDocument
     */
	public static func userEntitlementsIdGet(id: String, include: [String]? = nil) async throws -> UserEntitlementsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserEntitlementsAPI.userEntitlementsIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserEntitlementsMultiRelationshipDataDocument
     */
	public static func userEntitlementsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserEntitlementsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserEntitlementsAPI.userEntitlementsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
