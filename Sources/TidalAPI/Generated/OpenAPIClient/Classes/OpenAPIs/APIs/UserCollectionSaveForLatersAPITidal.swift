import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserCollectionSaveForLatersAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserCollectionSaveForLatersAPITidal.getResource()
/// ```
public enum UserCollectionSaveForLatersAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_userCollectionSaveForLatersIdGet: String, CaseIterable {
		case items = "items"
		case owners = "owners"

		func toUserCollectionSaveForLatersAPIEnum() -> UserCollectionSaveForLatersAPI.IncludeLinkage_userCollectionSaveForLatersIdGet {
			switch self {
			case .items: return .items
			case .owners: return .owners
			}
		}
	}

	/**
     Get single userCollectionSaveForLater.
     
     - returns: UserCollectionSaveForLatersSingleResourceDataDocument
     */
	public static func userCollectionSaveForLatersIdGet(id: String, include: [String]? = nil, includeLinkage: [UserCollectionSaveForLatersAPITidal.IncludeLinkage_userCollectionSaveForLatersIdGet]? = nil, replaceMedia: String? = nil) async throws -> UserCollectionSaveForLatersSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toUserCollectionSaveForLatersAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Delete from items relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func userCollectionSaveForLatersIdRelationshipsItemsDelete(id: String, idempotencyKey: String? = nil, userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload: UserCollectionSaveForLatersItemsRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdRelationshipsItemsDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload: userCollectionSaveForLatersItemsRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionSaveForLatersItemsMultiRelationshipDataDocument
     */
	public static func userCollectionSaveForLatersIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> UserCollectionSaveForLatersItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Add to items relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionSaveForLatersItemsAddMultiRelationshipDataDocument
     */
	public static func userCollectionSaveForLatersIdRelationshipsItemsPost(id: String, idempotencyKey: String? = nil, userCollectionSaveForLatersItemsRelationshipAddOperationPayload: UserCollectionSaveForLatersItemsRelationshipAddOperationPayload? = nil) async throws -> UserCollectionSaveForLatersItemsAddMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdRelationshipsItemsPostWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userCollectionSaveForLatersItemsRelationshipAddOperationPayload: userCollectionSaveForLatersItemsRelationshipAddOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionSaveForLatersOwnersMultiRelationshipDataDocument
     */
	public static func userCollectionSaveForLatersIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionSaveForLatersOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionSaveForLatersAPI.userCollectionSaveForLatersIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
