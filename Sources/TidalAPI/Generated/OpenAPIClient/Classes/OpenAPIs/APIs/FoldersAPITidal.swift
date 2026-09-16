import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `FoldersAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await FoldersAPITidal.getResource()
/// ```
public enum FoldersAPITidal {


	/**
     Delete single folder.
     
     - returns: MutationResponseDocument
     */
	public static func foldersIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			FoldersAPI.foldersIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
     Get single folder.
     
     - returns: FoldersSingleResourceDataDocument
     */
	public static func foldersIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> FoldersSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			FoldersAPI.foldersIdGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Update single folder.
     
     - returns: FoldersUpdateSingleResourceDataDocument
     */
	public static func foldersIdPatch(id: String, idempotencyKey: String? = nil, foldersUpdateOperationPayload: FoldersUpdateOperationPayload? = nil) async throws -> FoldersUpdateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			FoldersAPI.foldersIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, foldersUpdateOperationPayload: foldersUpdateOperationPayload)
		}
	}


	/**
     Get children relationship (\&quot;to-many\&quot;).
     
     - returns: FoldersChildrenMultiRelationshipDataDocument
     */
	public static func foldersIdRelationshipsChildrenGet(id: String, pageCursor: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> FoldersChildrenMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			FoldersAPI.foldersIdRelationshipsChildrenGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: FoldersOwnersMultiRelationshipDataDocument
     */
	public static func foldersIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> FoldersOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			FoldersAPI.foldersIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single folder.
     
     - returns: FoldersCreateSingleResourceDataDocument
     */
	public static func foldersPost(idempotencyKey: String? = nil, foldersCreateOperationPayload: FoldersCreateOperationPayload? = nil) async throws -> FoldersCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			FoldersAPI.foldersPostWithRequestBuilder(idempotencyKey: idempotencyKey, foldersCreateOperationPayload: foldersCreateOperationPayload)
		}
	}
}
