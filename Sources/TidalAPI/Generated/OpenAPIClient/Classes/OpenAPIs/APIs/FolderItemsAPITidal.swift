import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `FolderItemsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await FolderItemsAPITidal.getResource()
/// ```
public enum FolderItemsAPITidal {


	/**
     Delete single folderItem.
     
     - returns: MutationResponseDocument
     */
	public static func folderItemsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			FolderItemsAPI.folderItemsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
     Get single folderItem.
     
     - returns: FolderItemsSingleResourceDataDocument
     */
	public static func folderItemsIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> FolderItemsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			FolderItemsAPI.folderItemsIdGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: FolderItemsOwnersMultiRelationshipDataDocument
     */
	public static func folderItemsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> FolderItemsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			FolderItemsAPI.folderItemsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get parent relationship (\&quot;to-one\&quot;).
     
     - returns: FolderItemsParentSingleRelationshipDataDocument
     */
	public static func folderItemsIdRelationshipsParentGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> FolderItemsParentSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			FolderItemsAPI.folderItemsIdRelationshipsParentGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Update parent relationship (\&quot;to-one\&quot;).
     
     - returns: FolderItemsParentUpdateSingleRelationshipDataDocument
     */
	public static func folderItemsIdRelationshipsParentPatch(id: String, idempotencyKey: String? = nil, folderItemsParentRelationshipUpdateOperationPayload: FolderItemsParentRelationshipUpdateOperationPayload? = nil) async throws -> FolderItemsParentUpdateSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			FolderItemsAPI.folderItemsIdRelationshipsParentPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, folderItemsParentRelationshipUpdateOperationPayload: folderItemsParentRelationshipUpdateOperationPayload)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: FolderItemsSubjectSingleRelationshipDataDocument
     */
	public static func folderItemsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> FolderItemsSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			FolderItemsAPI.folderItemsIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Create single folderItem.
     
     - returns: FolderItemsCreateSingleResourceDataDocument
     */
	public static func folderItemsPost(idempotencyKey: String? = nil, folderItemsCreateOperationPayload: FolderItemsCreateOperationPayload? = nil) async throws -> FolderItemsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			FolderItemsAPI.folderItemsPostWithRequestBuilder(idempotencyKey: idempotencyKey, folderItemsCreateOperationPayload: folderItemsCreateOperationPayload)
		}
	}
}
