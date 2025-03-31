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
     Get all userEntitlements
     
     - returns: UserEntitlementsMultiDataDocument
     */
	public static func userEntitlementsGet(filterId: [String]? = nil) async throws -> UserEntitlementsMultiDataDocument {
		return try await RequestHelper.createRequest {
			UserEntitlementsAPI.userEntitlementsGetWithRequestBuilder(filterId: filterId)
		}
	}


	/**
     Get single userEntitlement
     
     - returns: UserEntitlementsSingleDataDocument
     */
	public static func userEntitlementsIdGet(id: String) async throws -> UserEntitlementsSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserEntitlementsAPI.userEntitlementsIdGetWithRequestBuilder(id: id)
		}
	}


	/**
     Get current user&#39;s userEntitlement data
     
     - returns: UserEntitlementsSingleDataDocument
     */
	public static func userEntitlementsMeGet() async throws -> UserEntitlementsSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserEntitlementsAPI.userEntitlementsMeGetWithRequestBuilder()
		}
	}
}
