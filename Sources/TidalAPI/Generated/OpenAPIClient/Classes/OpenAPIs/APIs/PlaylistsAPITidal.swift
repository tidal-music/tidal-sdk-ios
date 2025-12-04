import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `PlaylistsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await PlaylistsAPITidal.getResource()
/// ```
public enum PlaylistsAPITidal {


	/**
	 * enum for parameter sort
	 */
	public enum Sort_playlistsGet: String, CaseIterable {
		case CreatedAtAsc = "createdAt"
		case CreatedAtDesc = "-createdAt"
		case LastModifiedAtAsc = "lastModifiedAt"
		case LastModifiedAtDesc = "-lastModifiedAt"
		case NameAsc = "name"
		case NameDesc = "-name"

		func toPlaylistsAPIEnum() -> PlaylistsAPI.Sort_playlistsGet {
			switch self {
			case .CreatedAtAsc: return .CreatedAtAsc
			case .CreatedAtDesc: return .CreatedAtDesc
			case .LastModifiedAtAsc: return .LastModifiedAtAsc
			case .LastModifiedAtDesc: return .LastModifiedAtDesc
			case .NameAsc: return .NameAsc
			case .NameDesc: return .NameDesc
			}
		}
	}

	/**
     Get multiple playlists.
     
     - returns: PlaylistsMultiResourceDataDocument
     */
	public static func playlistsGet(pageCursor: String? = nil, sort: [PlaylistsAPITidal.Sort_playlistsGet]? = nil, countryCode: String? = nil, include: [String]? = nil, filterOwnersId: [String]? = nil, filterId: [String]? = nil) async throws -> PlaylistsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsGetWithRequestBuilder(pageCursor: pageCursor, sort: sort?.compactMap { $0.toPlaylistsAPIEnum() }, countryCode: countryCode, include: include, filterOwnersId: filterOwnersId, filterId: filterId)
		}
	}


	/**
     Delete single playlist.
     
     - returns: 
     */
	public static func playlistsIdDelete(id: String) async throws {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdDeleteWithRequestBuilder(id: id)
		}
	}


	/**
     Get single playlist.
     
     - returns: PlaylistsSingleResourceDataDocument
     */
	public static func playlistsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> PlaylistsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Update single playlist.
     
     - returns: 
     */
	public static func playlistsIdPatch(id: String, countryCode: String? = nil, playlistUpdateOperationPayload: PlaylistUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdPatchWithRequestBuilder(id: id, countryCode: countryCode, playlistUpdateOperationPayload: playlistUpdateOperationPayload)
		}
	}


	/**
     Get coverArt relationship (\&quot;to-many\&quot;).
     
     - returns: PlaylistsMultiRelationshipDataDocument
     */
	public static func playlistsIdRelationshipsCoverArtGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdRelationshipsCoverArtGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Update coverArt relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func playlistsIdRelationshipsCoverArtPatch(id: String, playlistCoverArtRelationshipUpdateOperationPayload: PlaylistCoverArtRelationshipUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdRelationshipsCoverArtPatchWithRequestBuilder(id: id, playlistCoverArtRelationshipUpdateOperationPayload: playlistCoverArtRelationshipUpdateOperationPayload)
		}
	}


	/**
     Delete from items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func playlistsIdRelationshipsItemsDelete(id: String, playlistItemsRelationshipRemoveOperationPayload: PlaylistItemsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdRelationshipsItemsDeleteWithRequestBuilder(id: id, playlistItemsRelationshipRemoveOperationPayload: playlistItemsRelationshipRemoveOperationPayload)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: PlaylistsItemsMultiRelationshipDataDocument
     */
	public static func playlistsIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> PlaylistsItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Update items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func playlistsIdRelationshipsItemsPatch(id: String, playlistItemsRelationshipReorderOperationPayload: PlaylistItemsRelationshipReorderOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdRelationshipsItemsPatchWithRequestBuilder(id: id, playlistItemsRelationshipReorderOperationPayload: playlistItemsRelationshipReorderOperationPayload)
		}
	}


	/**
     Add to items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func playlistsIdRelationshipsItemsPost(id: String, countryCode: String? = nil, playlistItemsRelationshipAddOperationPayload: PlaylistItemsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdRelationshipsItemsPostWithRequestBuilder(id: id, countryCode: countryCode, playlistItemsRelationshipAddOperationPayload: playlistItemsRelationshipAddOperationPayload)
		}
	}


	/**
     Get ownerProfiles relationship (\&quot;to-many\&quot;).
     
     - returns: PlaylistsMultiRelationshipDataDocument
     */
	public static func playlistsIdRelationshipsOwnerProfilesGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdRelationshipsOwnerProfilesGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: PlaylistsMultiRelationshipDataDocument
     */
	public static func playlistsIdRelationshipsOwnersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> PlaylistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsIdRelationshipsOwnersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single playlist.
     
     - returns: PlaylistsSingleResourceDataDocument
     */
	public static func playlistsPost(countryCode: String? = nil, playlistCreateOperationPayload: PlaylistCreateOperationPayload? = nil) async throws -> PlaylistsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			PlaylistsAPI.playlistsPostWithRequestBuilder(countryCode: countryCode, playlistCreateOperationPayload: playlistCreateOperationPayload)
		}
	}
}
