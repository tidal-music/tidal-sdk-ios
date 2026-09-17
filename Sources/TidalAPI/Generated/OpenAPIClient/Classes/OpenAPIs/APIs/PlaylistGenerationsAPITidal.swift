import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `PlaylistGenerationsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await PlaylistGenerationsAPITidal.getResource()
/// ```
public enum PlaylistGenerationsAPITidal {


	/**
     Get multiple playlistGenerations.
     
     - returns: PlaylistGenerationsMultiResourceDataDocument
     */
	public static func playlistGenerationsGet(filterPlaylistId: [String], include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationsAPI.playlistGenerationsGetWithRequestBuilder(filterPlaylistId: filterPlaylistId, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get single playlistGeneration.
     
     - returns: PlaylistGenerationsSingleResourceDataDocument
     */
	public static func playlistGenerationsIdGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationsAPI.playlistGenerationsIdGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get baseGeneration relationship (\&quot;to-one\&quot;).
     
     - returns: PlaylistGenerationsBaseGenerationSingleRelationshipDataDocument
     */
	public static func playlistGenerationsIdRelationshipsBaseGenerationGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationsBaseGenerationSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsBaseGenerationGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get playlist relationship (\&quot;to-one\&quot;).
     
     - returns: PlaylistGenerationsPlaylistSingleRelationshipDataDocument
     */
	public static func playlistGenerationsIdRelationshipsPlaylistGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationsPlaylistSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsPlaylistGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Delete from trackPreferences relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func playlistGenerationsIdRelationshipsTrackPreferencesDelete(id: String, idempotencyKey: String? = nil, playlistGenerationsTrackPreferencesRelationshipRemoveOperationPayload: PlaylistGenerationsTrackPreferencesRelationshipRemoveOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsTrackPreferencesDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, playlistGenerationsTrackPreferencesRelationshipRemoveOperationPayload: playlistGenerationsTrackPreferencesRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get trackPreferences relationship (\&quot;to-many\&quot;).
     
     - returns: PlaylistGenerationsTrackPreferencesMultiRelationshipDataDocument
     */
	public static func playlistGenerationsIdRelationshipsTrackPreferencesGet(id: String, pageCursor: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationsTrackPreferencesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsTrackPreferencesGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Update trackPreferences relationship (\&quot;to-many\&quot;).
     
     - returns: PlaylistGenerationsTrackPreferencesUpdateMultiRelationshipDataDocument
     */
	public static func playlistGenerationsIdRelationshipsTrackPreferencesPatch(id: String, idempotencyKey: String? = nil, playlistGenerationsTrackPreferencesRelationshipUpdateOperationPayload: PlaylistGenerationsTrackPreferencesRelationshipUpdateOperationPayload? = nil) async throws -> PlaylistGenerationsTrackPreferencesUpdateMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsTrackPreferencesPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, playlistGenerationsTrackPreferencesRelationshipUpdateOperationPayload: playlistGenerationsTrackPreferencesRelationshipUpdateOperationPayload)
		}
	}


	/**
     Add to trackPreferences relationship (\&quot;to-many\&quot;).
     
     - returns: PlaylistGenerationsTrackPreferencesAddMultiRelationshipDataDocument
     */
	public static func playlistGenerationsIdRelationshipsTrackPreferencesPost(id: String, idempotencyKey: String? = nil, playlistGenerationsTrackPreferencesRelationshipAddOperationPayload: PlaylistGenerationsTrackPreferencesRelationshipAddOperationPayload? = nil) async throws -> PlaylistGenerationsTrackPreferencesAddMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsTrackPreferencesPostWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, playlistGenerationsTrackPreferencesRelationshipAddOperationPayload: playlistGenerationsTrackPreferencesRelationshipAddOperationPayload)
		}
	}


	/**
     Create single playlistGeneration.
     
     - returns: PlaylistGenerationsCreateSingleResourceDataDocument
     */
	public static func playlistGenerationsPost(idempotencyKey: String? = nil, playlistGenerationsCreateOperationPayload: PlaylistGenerationsCreateOperationPayload? = nil) async throws -> PlaylistGenerationsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationsAPI.playlistGenerationsPostWithRequestBuilder(idempotencyKey: idempotencyKey, playlistGenerationsCreateOperationPayload: playlistGenerationsCreateOperationPayload)
		}
	}
}
