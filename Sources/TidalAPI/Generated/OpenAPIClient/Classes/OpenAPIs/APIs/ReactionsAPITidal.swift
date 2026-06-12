import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ReactionsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ReactionsAPITidal.getResource()
/// ```
public enum ReactionsAPITidal {


	/**
	 * enum for parameter filterSubjectType
	 */
	public enum FilterSubjectType_reactionsGet: String, CaseIterable {
		case albums = "albums"
		case tracks = "tracks"
		case artists = "artists"
		case videos = "videos"
		case playlists = "playlists"
		case comments = "comments"

		func toReactionsAPIEnum() -> ReactionsAPI.FilterSubjectType_reactionsGet {
			switch self {
			case .albums: return .albums
			case .tracks: return .tracks
			case .artists: return .artists
			case .videos: return .videos
			case .playlists: return .playlists
			case .comments: return .comments
			}
		}
	}

	/**
	 * enum for parameter stats
	 */
	public enum Stats_reactionsGet: String, CaseIterable {
		case all = "ALL"
		case countsByType = "COUNTS_BY_TYPE"
		case totalCount = "TOTAL_COUNT"

		func toReactionsAPIEnum() -> ReactionsAPI.Stats_reactionsGet {
			switch self {
			case .all: return .all
			case .countsByType: return .countsByType
			case .totalCount: return .totalCount
			}
		}
	}

	/**
     Get multiple reactions.
     
     - returns: ReactionsMultiResourceDataDocument
     */
	public static func reactionsGet(filterSubjectId: [String], filterSubjectType: [ReactionsAPITidal.FilterSubjectType_reactionsGet], stats: ReactionsAPITidal.Stats_reactionsGet? = nil, statsOnly: Bool? = nil, viewerContext: String? = nil, pageCursor: String? = nil, include: [String]? = nil, filterEmoji: [String]? = nil) async throws -> ReactionsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsGetWithRequestBuilder(filterSubjectId: filterSubjectId, filterSubjectType: filterSubjectType.compactMap { $0.toReactionsAPIEnum() }, stats: stats?.toReactionsAPIEnum(), statsOnly: statsOnly, viewerContext: viewerContext, pageCursor: pageCursor, include: include, filterEmoji: filterEmoji)
		}
	}


	/**
     Delete single reaction.
     
     - returns: 
     */
	public static func reactionsIdDelete(id: String, idempotencyKey: String? = nil) async throws {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
     Get ownerProfiles relationship (\&quot;to-many\&quot;).
     
     - returns: ReactionsMultiRelationshipDataDocument
     */
	public static func reactionsIdRelationshipsOwnerProfilesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ReactionsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdRelationshipsOwnerProfilesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ReactionsMultiRelationshipDataDocument
     */
	public static func reactionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ReactionsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single reaction.
     
     - returns: ReactionsSingleResourceDataDocument
     */
	public static func reactionsPost(idempotencyKey: String? = nil, reactionsCreateOperationPayload: ReactionsCreateOperationPayload? = nil) async throws -> ReactionsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsPostWithRequestBuilder(idempotencyKey: idempotencyKey, reactionsCreateOperationPayload: reactionsCreateOperationPayload)
		}
	}
}
