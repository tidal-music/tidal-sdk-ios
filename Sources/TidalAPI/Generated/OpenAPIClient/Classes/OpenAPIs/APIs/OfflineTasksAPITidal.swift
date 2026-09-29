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
     Get multiple offlineTasks.
     
     - returns: OfflineTasksMultiResourceDataDocument
     */
	public static func offlineTasksGet(filterInstallationId: [String], pageCursor: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> OfflineTasksMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksGetWithRequestBuilder(filterInstallationId: filterInstallationId, pageCursor: pageCursor, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get single offlineTask.
     
     - returns: OfflineTasksSingleResourceDataDocument
     */
	public static func offlineTasksIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> OfflineTasksSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksIdGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
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
