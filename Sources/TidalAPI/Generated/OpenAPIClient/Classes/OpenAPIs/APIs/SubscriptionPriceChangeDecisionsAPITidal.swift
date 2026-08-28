import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SubscriptionPriceChangeDecisionsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SubscriptionPriceChangeDecisionsAPITidal.getResource()
/// ```
public enum SubscriptionPriceChangeDecisionsAPITidal {


	/**
     Get multiple subscriptionPriceChangeDecisions.
     
     - returns: SubscriptionPriceChangeDecisionsMultiResourceDataDocument
     */
	public static func subscriptionPriceChangeDecisionsGet(filterOwnersId: [String], include: [String]? = nil) async throws -> SubscriptionPriceChangeDecisionsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			SubscriptionPriceChangeDecisionsAPI.subscriptionPriceChangeDecisionsGetWithRequestBuilder(filterOwnersId: filterOwnersId, include: include)
		}
	}


	/**
     Update single subscriptionPriceChangeDecision.
     
     - returns: SubscriptionPriceChangeDecisionsUpdateSingleResourceDataDocument
     */
	public static func subscriptionPriceChangeDecisionsIdPatch(id: String, idempotencyKey: String? = nil, subscriptionPriceChangeDecisionsUpdateOperationPayload: SubscriptionPriceChangeDecisionsUpdateOperationPayload? = nil) async throws -> SubscriptionPriceChangeDecisionsUpdateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SubscriptionPriceChangeDecisionsAPI.subscriptionPriceChangeDecisionsIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, subscriptionPriceChangeDecisionsUpdateOperationPayload: subscriptionPriceChangeDecisionsUpdateOperationPayload)
		}
	}


	/**
     Get priceChange relationship (\&quot;to-one\&quot;).
     
     - returns: SubscriptionPriceChangeDecisionsSingleRelationshipDataDocument
     */
	public static func subscriptionPriceChangeDecisionsIdRelationshipsPriceChangeGet(id: String, include: [String]? = nil) async throws -> SubscriptionPriceChangeDecisionsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SubscriptionPriceChangeDecisionsAPI.subscriptionPriceChangeDecisionsIdRelationshipsPriceChangeGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Create single subscriptionPriceChangeDecision.
     
     - returns: SubscriptionPriceChangeDecisionsCreateSingleResourceDataDocument
     */
	public static func subscriptionPriceChangeDecisionsPost(idempotencyKey: String? = nil, subscriptionPriceChangeDecisionsCreateOperationPayload: SubscriptionPriceChangeDecisionsCreateOperationPayload? = nil) async throws -> SubscriptionPriceChangeDecisionsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SubscriptionPriceChangeDecisionsAPI.subscriptionPriceChangeDecisionsPostWithRequestBuilder(idempotencyKey: idempotencyKey, subscriptionPriceChangeDecisionsCreateOperationPayload: subscriptionPriceChangeDecisionsCreateOperationPayload)
		}
	}
}
