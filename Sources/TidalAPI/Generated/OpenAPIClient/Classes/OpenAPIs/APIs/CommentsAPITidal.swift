import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `CommentsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await CommentsAPITidal.getResource()
/// ```
public enum CommentsAPITidal {


	/**
	 * enum for parameter sort
	 */
	public enum Sort_commentsGet: String, CaseIterable {
		case CreatedAtAsc = "createdAt"
		case CreatedAtDesc = "-createdAt"
		case LikeCountAsc = "likeCount"
		case LikeCountDesc = "-likeCount"
		case ReplyCountAsc = "replyCount"
		case ReplyCountDesc = "-replyCount"
		case StartTimeAsc = "startTime"
		case StartTimeDesc = "-startTime"

		func toCommentsAPIEnum() -> CommentsAPI.Sort_commentsGet {
			switch self {
			case .CreatedAtAsc: return .CreatedAtAsc
			case .CreatedAtDesc: return .CreatedAtDesc
			case .LikeCountAsc: return .LikeCountAsc
			case .LikeCountDesc: return .LikeCountDesc
			case .ReplyCountAsc: return .ReplyCountAsc
			case .ReplyCountDesc: return .ReplyCountDesc
			case .StartTimeAsc: return .StartTimeAsc
			case .StartTimeDesc: return .StartTimeDesc
			}
		}
	}

	/**
	 * enum for parameter filterSubjectType
	 */
	public enum FilterSubjectType_commentsGet: String, CaseIterable {
		case albums = "albums"
		case tracks = "tracks"

		func toCommentsAPIEnum() -> CommentsAPI.FilterSubjectType_commentsGet {
			switch self {
			case .albums: return .albums
			case .tracks: return .tracks
			}
		}
	}

	/**
     Get multiple comments.
     
     - returns: CommentsMultiResourceDataDocument
     */
	public static func commentsGet(pageCursor: String? = nil, sort: [CommentsAPITidal.Sort_commentsGet]? = nil, include: [String]? = nil, filterId: [String]? = nil, filterParentCommentId: [String]? = nil, filterSubjectId: [String]? = nil, filterSubjectType: [CommentsAPITidal.FilterSubjectType_commentsGet]? = nil) async throws -> CommentsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsGetWithRequestBuilder(pageCursor: pageCursor, sort: sort?.compactMap { $0.toCommentsAPIEnum() }, include: include, filterId: filterId, filterParentCommentId: filterParentCommentId, filterSubjectId: filterSubjectId, filterSubjectType: filterSubjectType?.compactMap { $0.toCommentsAPIEnum() })
		}
	}


	/**
     Delete single comment.
     
     - returns: 
     */
	public static func commentsIdDelete(id: String, idempotencyKey: String? = nil) async throws {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
     Get single comment.
     
     - returns: CommentsSingleResourceDataDocument
     */
	public static func commentsIdGet(id: String, include: [String]? = nil) async throws -> CommentsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Update single comment.
     
     - returns: 
     */
	public static func commentsIdPatch(id: String, idempotencyKey: String? = nil, commentsUpdateOperationPayload: CommentsUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, commentsUpdateOperationPayload: commentsUpdateOperationPayload)
		}
	}


	/**
     Get ownerProfiles relationship (\&quot;to-many\&quot;).
     
     - returns: CommentsMultiRelationshipDataDocument
     */
	public static func commentsIdRelationshipsOwnerProfilesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> CommentsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdRelationshipsOwnerProfilesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: CommentsMultiRelationshipDataDocument
     */
	public static func commentsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> CommentsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get parentComment relationship (\&quot;to-one\&quot;).
     
     - returns: CommentsSingleRelationshipDataDocument
     */
	public static func commentsIdRelationshipsParentCommentGet(id: String, include: [String]? = nil) async throws -> CommentsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdRelationshipsParentCommentGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Create single comment.
     
     - returns: CommentsSingleResourceDataDocument
     */
	public static func commentsPost(idempotencyKey: String? = nil, commentsCreateOperationPayload: CommentsCreateOperationPayload? = nil) async throws -> CommentsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsPostWithRequestBuilder(idempotencyKey: idempotencyKey, commentsCreateOperationPayload: commentsCreateOperationPayload)
		}
	}
}
