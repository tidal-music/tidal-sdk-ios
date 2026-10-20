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
		case tracksourcefiles = "trackSourceFiles"

		func toReactionsAPIEnum() -> ReactionsAPI.FilterSubjectType_reactionsGet {
			switch self {
			case .albums: return .albums
			case .tracks: return .tracks
			case .artists: return .artists
			case .videos: return .videos
			case .playlists: return .playlists
			case .comments: return .comments
			case .tracksourcefiles: return .tracksourcefiles
			}
		}
	}

	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_reactionsGet: String, CaseIterable {
		case author = "author"
		case ownerprofiles = "ownerProfiles"
		case owners = "owners"

		func toReactionsAPIEnum() -> ReactionsAPI.IncludeLinkage_reactionsGet {
			switch self {
			case .author: return .author
			case .ownerprofiles: return .ownerprofiles
			case .owners: return .owners
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
	public static func reactionsGet(filterEmoji: [String]? = nil, filterSubjectId: [String]? = nil, filterSubjectType: [ReactionsAPITidal.FilterSubjectType_reactionsGet]? = nil, filterSubject: String? = nil, include: [String]? = nil, includeLinkage: [ReactionsAPITidal.IncludeLinkage_reactionsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, stats: ReactionsAPITidal.Stats_reactionsGet? = nil, statsOnly: Bool? = nil, viewerContext: String? = nil) async throws -> ReactionsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsGetWithRequestBuilder(filterEmoji: filterEmoji, filterSubjectId: filterSubjectId, filterSubjectType: filterSubjectType?.compactMap { $0.toReactionsAPIEnum() }, filterSubject: filterSubject, include: include, includeLinkage: includeLinkage?.compactMap { $0.toReactionsAPIEnum() }, pageCursor: pageCursor, replaceMedia: replaceMedia, stats: stats?.toReactionsAPIEnum(), statsOnly: statsOnly, viewerContext: viewerContext)
		}
	}


	/**
     Delete single reaction.
     
     - returns: MutationResponseDocument
     */
	public static func reactionsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
     Get author relationship (\&quot;to-one\&quot;).
     
     - returns: ReactionsAuthorSingleRelationshipDataDocument
     */
	public static func reactionsIdRelationshipsAuthorGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ReactionsAuthorSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdRelationshipsAuthorGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get ownerProfiles relationship (\&quot;to-many\&quot;).
     
     - returns: ReactionsOwnerProfilesMultiRelationshipDataDocument
     */
	public static func reactionsIdRelationshipsOwnerProfilesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ReactionsOwnerProfilesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdRelationshipsOwnerProfilesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ReactionsOwnersMultiRelationshipDataDocument
     */
	public static func reactionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ReactionsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single reaction.
     
     - returns: ReactionsCreateSingleResourceDataDocument
     */
	public static func reactionsPost(idempotencyKey: String? = nil, reactionsCreateOperationPayload: ReactionsCreateOperationPayload? = nil) async throws -> ReactionsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ReactionsAPI.reactionsPostWithRequestBuilder(idempotencyKey: idempotencyKey, reactionsCreateOperationPayload: reactionsCreateOperationPayload)
		}
	}
}
