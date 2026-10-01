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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_playlistGenerationSchedulesGet: String, CaseIterable {
		case playlist = "playlist"

		func toPlaylistGenerationSchedulesAPIEnum() -> PlaylistGenerationSchedulesAPI.IncludeLinkage_playlistGenerationSchedulesGet {
			switch self {
			case .playlist: return .playlist
			}
		}
	}

	/**
     Get multiple playlistGenerationSchedules.
     
     - returns: PlaylistGenerationSchedulesMultiResourceDataDocument
     */
	public static func playlistGenerationSchedulesGet(filterPlaylistId: [String], include: [String]? = nil, includeLinkage: [PlaylistGenerationSchedulesAPITidal.IncludeLinkage_playlistGenerationSchedulesGet]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationSchedulesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesGetWithRequestBuilder(filterPlaylistId: filterPlaylistId, include: include, includeLinkage: includeLinkage?.compactMap { $0.toPlaylistGenerationSchedulesAPIEnum() }, replaceMedia: replaceMedia)
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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_playlistGenerationSchedulesIdGet: String, CaseIterable {
		case playlist = "playlist"

		func toPlaylistGenerationSchedulesAPIEnum() -> PlaylistGenerationSchedulesAPI.IncludeLinkage_playlistGenerationSchedulesIdGet {
			switch self {
			case .playlist: return .playlist
			}
		}
	}

	/**
     Get single playlistGenerationSchedule.
     
     - returns: PlaylistGenerationSchedulesSingleResourceDataDocument
     */
	public static func playlistGenerationSchedulesIdGet(id: String, include: [String]? = nil, includeLinkage: [PlaylistGenerationSchedulesAPITidal.IncludeLinkage_playlistGenerationSchedulesIdGet]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationSchedulesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationSchedulesAPI.playlistGenerationSchedulesIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toPlaylistGenerationSchedulesAPIEnum() }, replaceMedia: replaceMedia)
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
