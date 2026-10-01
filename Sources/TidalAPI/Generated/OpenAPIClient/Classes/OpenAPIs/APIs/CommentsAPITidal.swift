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
		case tracksourcefiles = "trackSourceFiles"

		func toCommentsAPIEnum() -> CommentsAPI.FilterSubjectType_commentsGet {
			switch self {
			case .albums: return .albums
			case .tracks: return .tracks
			case .tracksourcefiles: return .tracksourcefiles
			}
		}
	}

	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_commentsGet: String, CaseIterable {
		case author = "author"
		case owners = "owners"
		case parentcomment = "parentComment"

		func toCommentsAPIEnum() -> CommentsAPI.IncludeLinkage_commentsGet {
			switch self {
			case .author: return .author
			case .owners: return .owners
			case .parentcomment: return .parentcomment
			}
		}
	}

	/**
     Get multiple comments.
     
     - returns: CommentsMultiResourceDataDocument
     */
	public static func commentsGet(pageCursor: String? = nil, sort: [CommentsAPITidal.Sort_commentsGet]? = nil, include: [String]? = nil, filterParentCommentId: [String]? = nil, filterSubject: String? = nil, filterSubjectId: [String]? = nil, filterSubjectType: [CommentsAPITidal.FilterSubjectType_commentsGet]? = nil, includeLinkage: [CommentsAPITidal.IncludeLinkage_commentsGet]? = nil, replaceMedia: String? = nil) async throws -> CommentsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsGetWithRequestBuilder(pageCursor: pageCursor, sort: sort?.compactMap { $0.toCommentsAPIEnum() }, include: include, filterParentCommentId: filterParentCommentId, filterSubject: filterSubject, filterSubjectId: filterSubjectId, filterSubjectType: filterSubjectType?.compactMap { $0.toCommentsAPIEnum() }, includeLinkage: includeLinkage?.compactMap { $0.toCommentsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Delete single comment.
     
     - returns: MutationResponseDocument
     */
	public static func commentsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_commentsIdGet: String, CaseIterable {
		case author = "author"
		case owners = "owners"
		case parentcomment = "parentComment"

		func toCommentsAPIEnum() -> CommentsAPI.IncludeLinkage_commentsIdGet {
			switch self {
			case .author: return .author
			case .owners: return .owners
			case .parentcomment: return .parentcomment
			}
		}
	}

	/**
     Get single comment.
     
     - returns: CommentsSingleResourceDataDocument
     */
	public static func commentsIdGet(id: String, include: [String]? = nil, includeLinkage: [CommentsAPITidal.IncludeLinkage_commentsIdGet]? = nil, replaceMedia: String? = nil) async throws -> CommentsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toCommentsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Update single comment.
     
     - returns: MutationResponseDocument
     */
	public static func commentsIdPatch(id: String, idempotencyKey: String? = nil, commentsUpdateOperationPayload: CommentsUpdateOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, commentsUpdateOperationPayload: commentsUpdateOperationPayload)
		}
	}


	/**
     Get author relationship (\&quot;to-one\&quot;).
     
     - returns: CommentsAuthorSingleRelationshipDataDocument
     */
	public static func commentsIdRelationshipsAuthorGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> CommentsAuthorSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdRelationshipsAuthorGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: CommentsOwnersMultiRelationshipDataDocument
     */
	public static func commentsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> CommentsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get parentComment relationship (\&quot;to-one\&quot;).
     
     - returns: CommentsParentCommentSingleRelationshipDataDocument
     */
	public static func commentsIdRelationshipsParentCommentGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> CommentsParentCommentSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdRelationshipsParentCommentGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Create single comment.
     
     - returns: CommentsCreateSingleResourceDataDocument
     */
	public static func commentsPost(idempotencyKey: String? = nil, commentsCreateOperationPayload: CommentsCreateOperationPayload? = nil) async throws -> CommentsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsPostWithRequestBuilder(idempotencyKey: idempotencyKey, commentsCreateOperationPayload: commentsCreateOperationPayload)
		}
	}
}
