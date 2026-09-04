import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserPlaybackStatesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserPlaybackStatesAPITidal.getResource()
/// ```
public enum UserPlaybackStatesAPITidal {


	/**
     Get single userPlaybackState.
     
     - returns: UserPlaybackStatesSingleResourceDataDocument
     */
	public static func userPlaybackStatesIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> UserPlaybackStatesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Update single userPlaybackState.
     
     - returns: UserPlaybackStatesUpdateSingleResourceDataDocument
     */
	public static func userPlaybackStatesIdPatch(id: String, idempotencyKey: String? = nil, userPlaybackStatesUpdateOperationPayload: UserPlaybackStatesUpdateOperationPayload? = nil) async throws -> UserPlaybackStatesUpdateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesUpdateOperationPayload: userPlaybackStatesUpdateOperationPayload)
		}
	}


	/**
     Get activePlayer relationship (\&quot;to-one\&quot;).
     
     - returns: UserPlaybackStatesActivePlayerSingleRelationshipDataDocument
     */
	public static func userPlaybackStatesIdRelationshipsActivePlayerGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> UserPlaybackStatesActivePlayerSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsActivePlayerGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Update activePlayer relationship (\&quot;to-one\&quot;).
     
     - returns: UserPlaybackStatesActivePlayerUpdateSingleRelationshipDataDocument
     */
	public static func userPlaybackStatesIdRelationshipsActivePlayerPatch(id: String, idempotencyKey: String? = nil, userPlaybackStatesActivePlayerRelationshipUpdateOperationPayload: UserPlaybackStatesActivePlayerRelationshipUpdateOperationPayload? = nil) async throws -> UserPlaybackStatesActivePlayerUpdateSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsActivePlayerPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesActivePlayerRelationshipUpdateOperationPayload: userPlaybackStatesActivePlayerRelationshipUpdateOperationPayload)
		}
	}


	/**
     Delete from availablePlayers relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func userPlaybackStatesIdRelationshipsAvailablePlayersDelete(id: String, idempotencyKey: String? = nil, userPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload: UserPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsAvailablePlayersDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload: userPlaybackStatesAvailablePlayersRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get availablePlayers relationship (\&quot;to-many\&quot;).
     
     - returns: UserPlaybackStatesAvailablePlayersMultiRelationshipDataDocument
     */
	public static func userPlaybackStatesIdRelationshipsAvailablePlayersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> UserPlaybackStatesAvailablePlayersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsAvailablePlayersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Add to availablePlayers relationship (\&quot;to-many\&quot;).
     
     - returns: UserPlaybackStatesAvailablePlayersAddMultiRelationshipDataDocument
     */
	public static func userPlaybackStatesIdRelationshipsAvailablePlayersPost(id: String, idempotencyKey: String? = nil, userPlaybackStatesAvailablePlayersRelationshipAddOperationPayload: UserPlaybackStatesAvailablePlayersRelationshipAddOperationPayload? = nil) async throws -> UserPlaybackStatesAvailablePlayersAddMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsAvailablePlayersPostWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesAvailablePlayersRelationshipAddOperationPayload: userPlaybackStatesAvailablePlayersRelationshipAddOperationPayload)
		}
	}


	/**
     Get changeEventTopic relationship (\&quot;to-one\&quot;).
     
     - returns: UserPlaybackStatesChangeEventTopicSingleRelationshipDataDocument
     */
	public static func userPlaybackStatesIdRelationshipsChangeEventTopicGet(id: String, include: [String]? = nil) async throws -> UserPlaybackStatesChangeEventTopicSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsChangeEventTopicGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get playQueue relationship (\&quot;to-one\&quot;).
     
     - returns: UserPlaybackStatesPlayQueueSingleRelationshipDataDocument
     */
	public static func userPlaybackStatesIdRelationshipsPlayQueueGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> UserPlaybackStatesPlayQueueSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsPlayQueueGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Update playQueue relationship (\&quot;to-one\&quot;).
     
     - returns: UserPlaybackStatesPlayQueueUpdateSingleRelationshipDataDocument
     */
	public static func userPlaybackStatesIdRelationshipsPlayQueuePatch(id: String, idempotencyKey: String? = nil, userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload: UserPlaybackStatesPlayQueueRelationshipUpdateOperationPayload? = nil) async throws -> UserPlaybackStatesPlayQueueUpdateSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsPlayQueuePatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload: userPlaybackStatesPlayQueueRelationshipUpdateOperationPayload)
		}
	}
}
