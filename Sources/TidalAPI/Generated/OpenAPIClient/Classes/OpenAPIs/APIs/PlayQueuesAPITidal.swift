import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `PlayQueuesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await PlayQueuesAPITidal.getResource()
/// ```
public enum PlayQueuesAPITidal {


	/**
     Get multiple playQueues.
     
     - returns: PlayQueuesMultiResourceDataDocument
     */
	public static func playQueuesGet(pageCursor: String? = nil, include: [String]? = nil, filterOwnersId: [String]? = nil) async throws -> PlayQueuesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesGetWithRequestBuilder(pageCursor: pageCursor, include: include, filterOwnersId: filterOwnersId)
		}
	}


	/**
     Delete single playQueue.
     
     - returns: 
     */
	public static func playQueuesIdDelete(id: String) async throws {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesIdDeleteWithRequestBuilder(id: id)
		}
	}


	/**
     Get single playQueue.
     
     - returns: PlayQueuesSingleResourceDataDocument
     */
	public static func playQueuesIdGet(id: String, include: [String]? = nil) async throws -> PlayQueuesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Update single playQueue.
     
     - returns: 
     */
	public static func playQueuesIdPatch(id: String, playQueueUpdateOperationPayload: PlayQueueUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesIdPatchWithRequestBuilder(id: id, playQueueUpdateOperationPayload: playQueueUpdateOperationPayload)
		}
	}


	/**
     Get current relationship (\&quot;to-one\&quot;).
     
     - returns: PlayQueuesSingleRelationshipDataDocument
     */
	public static func playQueuesIdRelationshipsCurrentGet(id: String, include: [String]? = nil) async throws -> PlayQueuesSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesIdRelationshipsCurrentGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Update current relationship (\&quot;to-one\&quot;).
     
     - returns: 
     */
	public static func playQueuesIdRelationshipsCurrentPatch(id: String, playQueueUpdateCurrentOperationsPayload: PlayQueueUpdateCurrentOperationsPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesIdRelationshipsCurrentPatchWithRequestBuilder(id: id, playQueueUpdateCurrentOperationsPayload: playQueueUpdateCurrentOperationsPayload)
		}
	}


	/**
     Delete from future relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func playQueuesIdRelationshipsFutureDelete(id: String, playQueueRemoveFutureOperationPayload: PlayQueueRemoveFutureOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesIdRelationshipsFutureDeleteWithRequestBuilder(id: id, playQueueRemoveFutureOperationPayload: playQueueRemoveFutureOperationPayload)
		}
	}


	/**
     Get future relationship (\&quot;to-many\&quot;).
     
     - returns: PlayQueuesFutureMultiRelationshipDataDocument
     */
	public static func playQueuesIdRelationshipsFutureGet(id: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> PlayQueuesFutureMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesIdRelationshipsFutureGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Update future relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func playQueuesIdRelationshipsFuturePatch(id: String, playQueueUpdateFutureOperationPayload: PlayQueueUpdateFutureOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesIdRelationshipsFuturePatchWithRequestBuilder(id: id, playQueueUpdateFutureOperationPayload: playQueueUpdateFutureOperationPayload)
		}
	}


	/**
     Add to future relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func playQueuesIdRelationshipsFuturePost(id: String, playQueueAddFutureOperationPayload: PlayQueueAddFutureOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesIdRelationshipsFuturePostWithRequestBuilder(id: id, playQueueAddFutureOperationPayload: playQueueAddFutureOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: PlayQueuesMultiRelationshipDataDocument
     */
	public static func playQueuesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlayQueuesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get past relationship (\&quot;to-many\&quot;).
     
     - returns: PlayQueuesPastMultiRelationshipDataDocument
     */
	public static func playQueuesIdRelationshipsPastGet(id: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> PlayQueuesPastMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesIdRelationshipsPastGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Create single playQueue.
     
     - returns: PlayQueuesSingleResourceDataDocument
     */
	public static func playQueuesPost(playQueueCreateOperationPayload: PlayQueueCreateOperationPayload? = nil) async throws -> PlayQueuesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlayQueuesAPI.playQueuesPostWithRequestBuilder(playQueueCreateOperationPayload: playQueueCreateOperationPayload)
		}
	}
}
