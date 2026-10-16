import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SquareSitesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SquareSitesAPITidal.getResource()
/// ```
public enum SquareSitesAPITidal {


	/**
     Delete from items relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func squareSitesIdRelationshipsItemsDelete(id: String, idempotencyKey: String? = nil, squareSitesItemsRelationshipRemoveOperationPayload: SquareSitesItemsRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			SquareSitesAPI.squareSitesIdRelationshipsItemsDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, squareSitesItemsRelationshipRemoveOperationPayload: squareSitesItemsRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: SquareSitesItemsMultiRelationshipDataDocument
     */
	public static func squareSitesIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> SquareSitesItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SquareSitesAPI.squareSitesIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Add to items relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func squareSitesIdRelationshipsItemsPost(id: String, idempotencyKey: String? = nil, squareSitesItemsRelationshipAddOperationPayload: SquareSitesItemsRelationshipAddOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			SquareSitesAPI.squareSitesIdRelationshipsItemsPostWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, squareSitesItemsRelationshipAddOperationPayload: squareSitesItemsRelationshipAddOperationPayload)
		}
	}
}
