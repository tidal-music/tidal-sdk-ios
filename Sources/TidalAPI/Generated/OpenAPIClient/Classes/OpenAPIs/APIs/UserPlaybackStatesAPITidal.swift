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
     Delete from installations relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func userPlaybackStatesIdRelationshipsInstallationsDelete(id: String, idempotencyKey: String? = nil, userPlaybackStatesInstallationsRelationshipRemoveOperationPayload: UserPlaybackStatesInstallationsRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsInstallationsDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesInstallationsRelationshipRemoveOperationPayload: userPlaybackStatesInstallationsRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get installations relationship (\&quot;to-many\&quot;).
     
     - returns: UserPlaybackStatesInstallationsMultiRelationshipDataDocument
     */
	public static func userPlaybackStatesIdRelationshipsInstallationsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> UserPlaybackStatesInstallationsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsInstallationsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Add to installations relationship (\&quot;to-many\&quot;).
     
     - returns: UserPlaybackStatesInstallationsAddMultiRelationshipDataDocument
     */
	public static func userPlaybackStatesIdRelationshipsInstallationsPost(id: String, idempotencyKey: String? = nil, userPlaybackStatesInstallationsRelationshipAddOperationPayload: UserPlaybackStatesInstallationsRelationshipAddOperationPayload? = nil) async throws -> UserPlaybackStatesInstallationsAddMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsInstallationsPostWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesInstallationsRelationshipAddOperationPayload: userPlaybackStatesInstallationsRelationshipAddOperationPayload)
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


	/**
     Get player relationship (\&quot;to-one\&quot;).
     
     - returns: UserPlaybackStatesPlayerSingleRelationshipDataDocument
     */
	public static func userPlaybackStatesIdRelationshipsPlayerGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> UserPlaybackStatesPlayerSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsPlayerGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Update player relationship (\&quot;to-one\&quot;).
     
     - returns: UserPlaybackStatesPlayerUpdateSingleRelationshipDataDocument
     */
	public static func userPlaybackStatesIdRelationshipsPlayerPatch(id: String, idempotencyKey: String? = nil, userPlaybackStatesPlayerRelationshipUpdateOperationPayload: UserPlaybackStatesPlayerRelationshipUpdateOperationPayload? = nil) async throws -> UserPlaybackStatesPlayerUpdateSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserPlaybackStatesAPI.userPlaybackStatesIdRelationshipsPlayerPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userPlaybackStatesPlayerRelationshipUpdateOperationPayload: userPlaybackStatesPlayerRelationshipUpdateOperationPayload)
		}
	}
}
