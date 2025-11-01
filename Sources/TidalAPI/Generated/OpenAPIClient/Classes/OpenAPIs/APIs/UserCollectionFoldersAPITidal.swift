import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserCollectionFoldersAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserCollectionFoldersAPITidal.getResource()
/// ```
public enum UserCollectionFoldersAPITidal {


	/**
     Get multiple userCollectionFolders.
     
     - returns: UserCollectionFoldersMultiResourceDataDocument
     */
	public static func userCollectionFoldersGet(include: [String]? = nil, filterId: [String]? = nil) async throws -> UserCollectionFoldersMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionFoldersAPI.userCollectionFoldersGetWithRequestBuilder(include: include, filterId: filterId)
		}
	}


	/**
     Delete single userCollectionFolder.
     
     - returns: 
     */
	public static func userCollectionFoldersIdDelete(id: String) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionFoldersAPI.userCollectionFoldersIdDeleteWithRequestBuilder(id: id)
		}
	}


	/**
     Get single userCollectionFolder.
     
     - returns: UserCollectionFoldersSingleResourceDataDocument
     */
	public static func userCollectionFoldersIdGet(id: String, include: [String]? = nil) async throws -> UserCollectionFoldersSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionFoldersAPI.userCollectionFoldersIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Update single userCollectionFolder.
     
     - returns: 
     */
	public static func userCollectionFoldersIdPatch(id: String, folderUpdateOperationPayload: FolderUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionFoldersAPI.userCollectionFoldersIdPatchWithRequestBuilder(id: id, folderUpdateOperationPayload: folderUpdateOperationPayload)
		}
	}


	/**
     Delete from items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionFoldersIdRelationshipsItemsDelete(removePayload: RemovePayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionFoldersAPI.userCollectionFoldersIdRelationshipsItemsDeleteWithRequestBuilder(removePayload: removePayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionFoldersIdRelationshipsItemsGet: String, CaseIterable {
		case ItemsAddedAtAsc = "items.addedAt"
		case ItemsAddedAtDesc = "-items.addedAt"
		case ItemsLastModifiedAtAsc = "items.lastModifiedAt"
		case ItemsLastModifiedAtDesc = "-items.lastModifiedAt"
		case ItemsNameAsc = "items.name"
		case ItemsNameDesc = "-items.name"

		func toUserCollectionFoldersAPIEnum() -> UserCollectionFoldersAPI.Sort_userCollectionFoldersIdRelationshipsItemsGet {
			switch self {
			case .ItemsAddedAtAsc: return .ItemsAddedAtAsc
			case .ItemsAddedAtDesc: return .ItemsAddedAtDesc
			case .ItemsLastModifiedAtAsc: return .ItemsLastModifiedAtAsc
			case .ItemsLastModifiedAtDesc: return .ItemsLastModifiedAtDesc
			case .ItemsNameAsc: return .ItemsNameAsc
			case .ItemsNameDesc: return .ItemsNameDesc
			}
		}
	}

	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionFoldersItemsMultiRelationshipDataDocument
     */
	public static func userCollectionFoldersIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, sort: [UserCollectionFoldersAPITidal.Sort_userCollectionFoldersIdRelationshipsItemsGet]? = nil, include: [String]? = nil) async throws -> UserCollectionFoldersItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionFoldersAPI.userCollectionFoldersIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionFoldersAPIEnum() }, include: include)
		}
	}


	/**
     Add to items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionFoldersIdRelationshipsItemsPost(id: String, addPayload: AddPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionFoldersAPI.userCollectionFoldersIdRelationshipsItemsPostWithRequestBuilder(id: id, addPayload: addPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionFoldersMultiRelationshipDataDocument
     */
	public static func userCollectionFoldersIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionFoldersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionFoldersAPI.userCollectionFoldersIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single userCollectionFolder.
     
     - returns: UserCollectionFoldersSingleResourceDataDocument
     */
	public static func userCollectionFoldersPost(folderCreateOperationPayload: FolderCreateOperationPayload? = nil) async throws -> UserCollectionFoldersSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionFoldersAPI.userCollectionFoldersPostWithRequestBuilder(folderCreateOperationPayload: folderCreateOperationPayload)
		}
	}
}
