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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_userSubscriptionPriceChangesGet: String, CaseIterable {
		case decision = "decision"

		func toUserSubscriptionPriceChangesAPIEnum() -> UserSubscriptionPriceChangesAPI.IncludeLinkage_userSubscriptionPriceChangesGet {
			switch self {
			case .decision: return .decision
			}
		}
	}

	/**
     Get multiple userSubscriptionPriceChanges.
     
     - returns: UserSubscriptionPriceChangesMultiResourceDataDocument
     */
	public static func userSubscriptionPriceChangesGet(filterOwnersId: [String], include: [String]? = nil, includeLinkage: [UserSubscriptionPriceChangesAPITidal.IncludeLinkage_userSubscriptionPriceChangesGet]? = nil) async throws -> UserSubscriptionPriceChangesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserSubscriptionPriceChangesAPI.userSubscriptionPriceChangesGetWithRequestBuilder(filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage?.compactMap { $0.toUserSubscriptionPriceChangesAPIEnum() })
		}
	}


	/**
     Get decision relationship (\&quot;to-one\&quot;).
     
     - returns: UserSubscriptionPriceChangesDecisionSingleRelationshipDataDocument
     */
	public static func userSubscriptionPriceChangesIdRelationshipsDecisionGet(id: String, include: [String]? = nil) async throws -> UserSubscriptionPriceChangesDecisionSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserSubscriptionPriceChangesAPI.userSubscriptionPriceChangesIdRelationshipsDecisionGetWithRequestBuilder(id: id, include: include)
		}
	}
}
