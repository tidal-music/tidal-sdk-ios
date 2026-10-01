import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `OfflineTasksAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await OfflineTasksAPITidal.getResource()
/// ```
public enum OfflineTasksAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_offlineTasksGet: String, CaseIterable {
		case collection = "collection"
		case item = "item"
		case owners = "owners"

		func toOfflineTasksAPIEnum() -> OfflineTasksAPI.IncludeLinkage_offlineTasksGet {
			switch self {
			case .collection: return .collection
			case .item: return .item
			case .owners: return .owners
			}
		}
	}

	/**
     Get multiple offlineTasks.
     
     - returns: OfflineTasksMultiResourceDataDocument
     */
	public static func offlineTasksGet(filterInstallationId: [String], pageCursor: String? = nil, include: [String]? = nil, includeLinkage: [OfflineTasksAPITidal.IncludeLinkage_offlineTasksGet]? = nil, replaceMedia: String? = nil) async throws -> OfflineTasksMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksGetWithRequestBuilder(filterInstallationId: filterInstallationId, pageCursor: pageCursor, include: include, includeLinkage: includeLinkage?.compactMap { $0.toOfflineTasksAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_offlineTasksIdGet: String, CaseIterable {
		case collection = "collection"
		case item = "item"
		case owners = "owners"

		func toOfflineTasksAPIEnum() -> OfflineTasksAPI.IncludeLinkage_offlineTasksIdGet {
			switch self {
			case .collection: return .collection
			case .item: return .item
			case .owners: return .owners
			}
		}
	}

	/**
     Get single offlineTask.
     
     - returns: OfflineTasksSingleResourceDataDocument
     */
	public static func offlineTasksIdGet(id: String, include: [String]? = nil, includeLinkage: [OfflineTasksAPITidal.IncludeLinkage_offlineTasksIdGet]? = nil, replaceMedia: String? = nil) async throws -> OfflineTasksSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toOfflineTasksAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Update single offlineTask.
     
     - returns: MutationResponseDocument
     */
	public static func offlineTasksIdPatch(id: String, idempotencyKey: String? = nil, offlineTasksUpdateOperationPayload: OfflineTasksUpdateOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, offlineTasksUpdateOperationPayload: offlineTasksUpdateOperationPayload)
		}
	}


	/**
     Get collection relationship (\&quot;to-one\&quot;).
     
     - returns: OfflineTasksCollectionSingleRelationshipDataDocument
     */
	public static func offlineTasksIdRelationshipsCollectionGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> OfflineTasksCollectionSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksIdRelationshipsCollectionGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get item relationship (\&quot;to-one\&quot;).
     
     - returns: OfflineTasksItemSingleRelationshipDataDocument
     */
	public static func offlineTasksIdRelationshipsItemGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> OfflineTasksItemSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksIdRelationshipsItemGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: OfflineTasksOwnersMultiRelationshipDataDocument
     */
	public static func offlineTasksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> OfflineTasksOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
