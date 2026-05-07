import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ClientsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ClientsAPITidal.getResource()
/// ```
public enum ClientsAPITidal {


	/**
     Get multiple clients.
     
     - returns: ClientsMultiResourceDataDocument
     */
	public static func clientsGet(include: [String]? = nil, filterOwnersId: [String]? = nil) async throws -> ClientsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ClientsAPI.clientsGetWithRequestBuilder(include: include, filterOwnersId: filterOwnersId)
		}
	}


	/**
     Delete single client.
     
     - returns: 
     */
	public static func clientsIdDelete(id: String, idempotencyKey: String? = nil) async throws {
		return try await RequestHelper.createRequest {
			ClientsAPI.clientsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
     Get single client.
     
     - returns: ClientsSingleResourceDataDocument
     */
	public static func clientsIdGet(id: String, include: [String]? = nil) async throws -> ClientsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ClientsAPI.clientsIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Update single client.
     
     - returns: 
     */
	public static func clientsIdPatch(id: String, idempotencyKey: String? = nil, clientsUpdateOperationPayload: ClientsUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			ClientsAPI.clientsIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, clientsUpdateOperationPayload: clientsUpdateOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ClientsMultiRelationshipDataDocument
     */
	public static func clientsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ClientsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ClientsAPI.clientsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single client.
     
     - returns: ClientsSingleResourceDataDocument
     */
	public static func clientsPost(idempotencyKey: String? = nil, clientsCreateOperationPayload: ClientsCreateOperationPayload? = nil) async throws -> ClientsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ClientsAPI.clientsPostWithRequestBuilder(idempotencyKey: idempotencyKey, clientsCreateOperationPayload: clientsCreateOperationPayload)
		}
	}
}
