import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `StripeConnectionsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await StripeConnectionsAPITidal.getResource()
/// ```
public enum StripeConnectionsAPITidal {


	/**
     Get multiple stripeConnections.
     
     - returns: StripeConnectionsMultiResourceDataDocument
     */
	public static func stripeConnectionsGet(filterOwnersId: [String], include: [String]? = nil) async throws -> StripeConnectionsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			StripeConnectionsAPI.stripeConnectionsGetWithRequestBuilder(filterOwnersId: filterOwnersId, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: StripeConnectionsOwnersMultiRelationshipDataDocument
     */
	public static func stripeConnectionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> StripeConnectionsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			StripeConnectionsAPI.stripeConnectionsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single stripeConnection.
     
     - returns: StripeConnectionsCreateSingleResourceDataDocument
     */
	public static func stripeConnectionsPost(idempotencyKey: String? = nil, stripeConnectionsCreateOperationPayload: StripeConnectionsCreateOperationPayload? = nil) async throws -> StripeConnectionsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			StripeConnectionsAPI.stripeConnectionsPostWithRequestBuilder(idempotencyKey: idempotencyKey, stripeConnectionsCreateOperationPayload: stripeConnectionsCreateOperationPayload)
		}
	}
}
