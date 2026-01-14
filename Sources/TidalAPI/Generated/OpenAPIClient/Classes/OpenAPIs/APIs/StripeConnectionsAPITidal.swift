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
	public static func stripeConnectionsGet(include: [String]? = nil, filterOwnersId: [String]? = nil) async throws -> StripeConnectionsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			StripeConnectionsAPI.stripeConnectionsGetWithRequestBuilder(include: include, filterOwnersId: filterOwnersId)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: StripeConnectionsMultiRelationshipDataDocument
     */
	public static func stripeConnectionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> StripeConnectionsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			StripeConnectionsAPI.stripeConnectionsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single stripeConnection.
     
     - returns: StripeConnectionsSingleResourceDataDocument
     */
	public static func stripeConnectionsPost(countryCode: String? = nil, stripeConnectionsCreateOperationPayload: StripeConnectionsCreateOperationPayload? = nil) async throws -> StripeConnectionsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			StripeConnectionsAPI.stripeConnectionsPostWithRequestBuilder(countryCode: countryCode, stripeConnectionsCreateOperationPayload: stripeConnectionsCreateOperationPayload)
		}
	}
}
