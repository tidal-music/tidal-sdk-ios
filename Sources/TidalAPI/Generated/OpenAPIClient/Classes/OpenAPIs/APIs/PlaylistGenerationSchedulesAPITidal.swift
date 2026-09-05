import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `PlaylistGenerationSchedulesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await PlaylistGenerationSchedulesAPITidal.getResource()
/// ```
public enum PlaylistGenerationSchedulesAPITidal {


	/**
     Get multiple playlistGenerationSchedules.
     
     - returns: PlaylistGenerationSchedulesMultiResourceDataDocument
     */
	public static func playlistGenerationSchedulesGet(filterPlaylistId: [String], include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationSchedulesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesGetWithRequestBuilder(filterPlaylistId: filterPlaylistId, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Delete single playlistGenerationSchedule.
     
     - returns: MutationResponseDocument
     */
	public static func playlistGenerationSchedulesIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
     Get single playlistGenerationSchedule.
     
     - returns: PlaylistGenerationSchedulesSingleResourceDataDocument
     */
	public static func playlistGenerationSchedulesIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationSchedulesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesIdGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Update single playlistGenerationSchedule.
     
     - returns: PlaylistGenerationSchedulesUpdateSingleResourceDataDocument
     */
	public static func playlistGenerationSchedulesIdPatch(id: String, idempotencyKey: String? = nil, playlistGenerationSchedulesUpdateOperationPayload: PlaylistGenerationSchedulesUpdateOperationPayload? = nil) async throws -> PlaylistGenerationSchedulesUpdateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, playlistGenerationSchedulesUpdateOperationPayload: playlistGenerationSchedulesUpdateOperationPayload)
		}
	}


	/**
     Get playlist relationship (\&quot;to-one\&quot;).
     
     - returns: PlaylistGenerationSchedulesPlaylistSingleRelationshipDataDocument
     */
	public static func playlistGenerationSchedulesIdRelationshipsPlaylistGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationSchedulesPlaylistSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesIdRelationshipsPlaylistGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Create single playlistGenerationSchedule.
     
     - returns: PlaylistGenerationSchedulesCreateSingleResourceDataDocument
     */
	public static func playlistGenerationSchedulesPost(idempotencyKey: String? = nil, playlistGenerationSchedulesCreateOperationPayload: PlaylistGenerationSchedulesCreateOperationPayload? = nil) async throws -> PlaylistGenerationSchedulesCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesPostWithRequestBuilder(idempotencyKey: idempotencyKey, playlistGenerationSchedulesCreateOperationPayload: playlistGenerationSchedulesCreateOperationPayload)
		}
	}
}
