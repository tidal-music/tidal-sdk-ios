import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserCollectionPlaylistsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserCollectionPlaylistsAPITidal.getResource()
/// ```
public enum UserCollectionPlaylistsAPITidal {


	/**
     Get single userCollectionPlaylist.
     
     - returns: UserCollectionPlaylistsSingleResourceDataDocument
     */
	public static func userCollectionPlaylistsIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionPlaylistsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionPlaylistsAPI.userCollectionPlaylistsIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Delete from items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionPlaylistsIdRelationshipsItemsDelete(id: String, userCollectionPlaylistsItemsRelationshipRemoveOperationPayload: UserCollectionPlaylistsItemsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionPlaylistsAPI.userCollectionPlaylistsIdRelationshipsItemsDeleteWithRequestBuilder(id: id, userCollectionPlaylistsItemsRelationshipRemoveOperationPayload: userCollectionPlaylistsItemsRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter collectionView
	 */
	public enum CollectionView_userCollectionPlaylistsIdRelationshipsItemsGet: String, CaseIterable {
		case folders = "FOLDERS"

		func toUserCollectionPlaylistsAPIEnum() -> UserCollectionPlaylistsAPI.CollectionView_userCollectionPlaylistsIdRelationshipsItemsGet {
			switch self {
			case .folders: return .folders
			}
		}
	}

	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionPlaylistsIdRelationshipsItemsGet: String, CaseIterable {
		case AddedAtAsc = "addedAt"
		case AddedAtDesc = "-addedAt"
		case LastModifiedAtAsc = "lastModifiedAt"
		case LastModifiedAtDesc = "-lastModifiedAt"
		case NameAsc = "name"
		case NameDesc = "-name"

		func toUserCollectionPlaylistsAPIEnum() -> UserCollectionPlaylistsAPI.Sort_userCollectionPlaylistsIdRelationshipsItemsGet {
			switch self {
			case .AddedAtAsc: return .AddedAtAsc
			case .AddedAtDesc: return .AddedAtDesc
			case .LastModifiedAtAsc: return .LastModifiedAtAsc
			case .LastModifiedAtDesc: return .LastModifiedAtDesc
			case .NameAsc: return .NameAsc
			case .NameDesc: return .NameDesc
			}
		}
	}

	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionPlaylistsItemsMultiRelationshipDataDocument
     */
	public static func userCollectionPlaylistsIdRelationshipsItemsGet(id: String, collectionView: UserCollectionPlaylistsAPITidal.CollectionView_userCollectionPlaylistsIdRelationshipsItemsGet? = nil, pageCursor: String? = nil, sort: [UserCollectionPlaylistsAPITidal.Sort_userCollectionPlaylistsIdRelationshipsItemsGet]? = nil, include: [String]? = nil) async throws -> UserCollectionPlaylistsItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionPlaylistsAPI.userCollectionPlaylistsIdRelationshipsItemsGetWithRequestBuilder(id: id, collectionView: collectionView?.toUserCollectionPlaylistsAPIEnum(), pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionPlaylistsAPIEnum() }, include: include)
		}
	}


	/**
     Add to items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionPlaylistsIdRelationshipsItemsPost(id: String, userCollectionPlaylistsItemsRelationshipAddOperationPayload: UserCollectionPlaylistsItemsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionPlaylistsAPI.userCollectionPlaylistsIdRelationshipsItemsPostWithRequestBuilder(id: id, userCollectionPlaylistsItemsRelationshipAddOperationPayload: userCollectionPlaylistsItemsRelationshipAddOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionPlaylistsMultiRelationshipDataDocument
     */
	public static func userCollectionPlaylistsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionPlaylistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionPlaylistsAPI.userCollectionPlaylistsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
