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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_clientsGet: String, CaseIterable {
		case owners = "owners"

		func toClientsAPIEnum() -> ClientsAPI.IncludeLinkage_clientsGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get multiple clients.
     
     - returns: ClientsMultiResourceDataDocument
     */
	public static func clientsGet(filterOwnersId: [String], include: [String]? = nil, includeLinkage: [ClientsAPITidal.IncludeLinkage_clientsGet]? = nil) async throws -> ClientsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ClientsAPI.clientsGetWithRequestBuilder(filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage?.compactMap { $0.toClientsAPIEnum() })
		}
	}


	/**
     Delete single client.
     
     - returns: MutationResponseDocument
     */
	public static func clientsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			ClientsAPI.clientsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_clientsIdGet: String, CaseIterable {
		case owners = "owners"

		func toClientsAPIEnum() -> ClientsAPI.IncludeLinkage_clientsIdGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get single client.
     
     - returns: ClientsSingleResourceDataDocument
     */
	public static func clientsIdGet(id: String, include: [String]? = nil, includeLinkage: [ClientsAPITidal.IncludeLinkage_clientsIdGet]? = nil) async throws -> ClientsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ClientsAPI.clientsIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toClientsAPIEnum() })
		}
	}


	/**
     Update single client.
     
     - returns: ClientsUpdateSingleResourceDataDocument
     */
	public static func clientsIdPatch(id: String, idempotencyKey: String? = nil, clientsUpdateOperationPayload: ClientsUpdateOperationPayload? = nil) async throws -> ClientsUpdateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ClientsAPI.clientsIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, clientsUpdateOperationPayload: clientsUpdateOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ClientsOwnersMultiRelationshipDataDocument
     */
	public static func clientsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ClientsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ClientsAPI.clientsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single client.
     
     - returns: ClientsCreateSingleResourceDataDocument
     */
	public static func clientsPost(idempotencyKey: String? = nil, clientsCreateOperationPayload: ClientsCreateOperationPayload? = nil) async throws -> ClientsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ClientsAPI.clientsPostWithRequestBuilder(idempotencyKey: idempotencyKey, clientsCreateOperationPayload: clientsCreateOperationPayload)
		}
	}
}
