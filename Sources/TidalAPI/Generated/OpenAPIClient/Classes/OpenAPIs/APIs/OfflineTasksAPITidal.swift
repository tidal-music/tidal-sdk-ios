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
	public static func offlineTasksGet(pageCursor: String? = nil, include: [String]? = nil, filterId: [String]? = nil, filterInstallationId: [String]? = nil) async throws -> OfflineTasksMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksGetWithRequestBuilder(pageCursor: pageCursor, include: include, filterId: filterId, filterInstallationId: filterInstallationId)
		}
	}


	/**
     Get single offlineTask.
     
     - returns: OfflineTasksSingleResourceDataDocument
     */
	public static func offlineTasksIdGet(id: String, include: [String]? = nil) async throws -> OfflineTasksSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Update single offlineTask.
     
     - returns: 
     */
	public static func offlineTasksIdPatch(id: String, offlineTasksUpdateOperationPayload: OfflineTasksUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksIdPatchWithRequestBuilder(id: id, offlineTasksUpdateOperationPayload: offlineTasksUpdateOperationPayload)
		}
	}


	/**
     Get item relationship (\&quot;to-one\&quot;).
     
     - returns: OfflineTasksSingleRelationshipDataDocument
     */
	public static func offlineTasksIdRelationshipsItemGet(id: String, include: [String]? = nil) async throws -> OfflineTasksSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksIdRelationshipsItemGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: OfflineTasksMultiRelationshipDataDocument
     */
	public static func offlineTasksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> OfflineTasksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			OfflineTasksAPI.offlineTasksIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
