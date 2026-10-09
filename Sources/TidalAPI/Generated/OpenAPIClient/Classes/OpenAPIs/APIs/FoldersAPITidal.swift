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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_foldersGet: String, CaseIterable {
		case children = "children"
		case owners = "owners"
		case parent = "parent"
		case preview = "preview"

		func toFoldersAPIEnum() -> FoldersAPI.IncludeLinkage_foldersGet {
			switch self {
			case .children: return .children
			case .owners: return .owners
			case .parent: return .parent
			case .preview: return .preview
			}
		}
	}

	/**
     Get multiple folders.
     
     - returns: FoldersMultiResourceDataDocument
     */
	public static func foldersGet(filterId: [String], include: [String]? = nil, includeLinkage: [FoldersAPITidal.IncludeLinkage_foldersGet]? = nil, replaceMedia: String? = nil) async throws -> FoldersMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			FoldersAPI.foldersGetWithRequestBuilder(filterId: filterId, include: include, includeLinkage: includeLinkage?.compactMap { $0.toFoldersAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_foldersIdGet: String, CaseIterable {
		case children = "children"
		case owners = "owners"
		case parent = "parent"
		case preview = "preview"

		func toFoldersAPIEnum() -> FoldersAPI.IncludeLinkage_foldersIdGet {
			switch self {
			case .children: return .children
			case .owners: return .owners
			case .parent: return .parent
			case .preview: return .preview
			}
		}
	}

	/**
     Get single folder.
     
     - returns: FoldersSingleResourceDataDocument
     */
	public static func foldersIdGet(id: String, include: [String]? = nil, includeLinkage: [FoldersAPITidal.IncludeLinkage_foldersIdGet]? = nil, replaceMedia: String? = nil) async throws -> FoldersSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			FoldersAPI.foldersIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toFoldersAPIEnum() }, replaceMedia: replaceMedia)
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
     Get parent relationship (\&quot;to-one\&quot;).
     
     - returns: FoldersParentSingleRelationshipDataDocument
     */
	public static func foldersIdRelationshipsParentGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> FoldersParentSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			FoldersAPI.foldersIdRelationshipsParentGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get preview relationship (\&quot;to-many\&quot;).
     
     - returns: FoldersPreviewMultiRelationshipDataDocument
     */
	public static func foldersIdRelationshipsPreviewGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> FoldersPreviewMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			FoldersAPI.foldersIdRelationshipsPreviewGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
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
