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
     Get playlist relationship (\&quot;to-one\&quot;).
     
     - returns: PlaylistGenerationsPlaylistSingleRelationshipDataDocument
     */
	public static func playlistGenerationsIdRelationshipsPlaylistGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> PlaylistGenerationsPlaylistSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistGenerationsAPI.playlistGenerationsIdRelationshipsPlaylistGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
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
