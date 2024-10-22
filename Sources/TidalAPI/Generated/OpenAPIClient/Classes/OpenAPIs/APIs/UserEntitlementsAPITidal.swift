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
/// let dataDocument = try await UserEntitlementsAPI.getResource()
/// ```
public enum UserEntitlementsAPITidal {


	/**
     Get the current users entitlements
     
     - returns: UserEntitlementsSingleDataDocument
     */
	public static func getMyUserEntitlements(include: [String]? = nil) async throws -> UserEntitlementsSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserEntitlementsAPI.getMyUserEntitlementsWithRequestBuilder(include: include)
		}
	}


	/**
     Get user entitlements for user
     
     - returns: UserEntitlementsSingleDataDocument
     */
	public static func getUserEntitlementsById(id: String, include: [String]? = nil) async throws -> UserEntitlementsSingleDataDocument {
		return try await RequestHelper.createRequest {
			UserEntitlementsAPI.getUserEntitlementsByIdWithRequestBuilder(id: id, include: include)
		}
	}
}
