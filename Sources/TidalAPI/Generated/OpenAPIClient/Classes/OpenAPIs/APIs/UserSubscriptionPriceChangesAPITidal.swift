import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserSubscriptionPriceChangesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserSubscriptionPriceChangesAPITidal.getResource()
/// ```
public enum UserSubscriptionPriceChangesAPITidal {


	/**
     Get multiple userSubscriptionPriceChanges.
     
     - returns: UserSubscriptionPriceChangesMultiResourceDataDocument
     */
	public static func userSubscriptionPriceChangesGet(filterOwnersId: [String], include: [String]? = nil) async throws -> UserSubscriptionPriceChangesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserSubscriptionPriceChangesAPI.userSubscriptionPriceChangesGetWithRequestBuilder(filterOwnersId: filterOwnersId, include: include)
		}
	}


	/**
     Get decision relationship (\&quot;to-one\&quot;).
     
     - returns: UserSubscriptionPriceChangesSingleRelationshipDataDocument
     */
	public static func userSubscriptionPriceChangesIdRelationshipsDecisionGet(id: String, include: [String]? = nil) async throws -> UserSubscriptionPriceChangesSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserSubscriptionPriceChangesAPI.userSubscriptionPriceChangesIdRelationshipsDecisionGetWithRequestBuilder(id: id, include: include)
		}
	}
}
