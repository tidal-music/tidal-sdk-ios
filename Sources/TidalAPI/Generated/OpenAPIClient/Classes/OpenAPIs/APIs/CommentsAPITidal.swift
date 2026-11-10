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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_commentsGet: String, CaseIterable {
		case author = "author"
		case commentsummary = "commentSummary"
		case owners = "owners"
		case reactionsummary = "reactionSummary"
		case rootsubject = "rootSubject"
		case subject = "subject"

		func toCommentsAPIEnum() -> CommentsAPI.IncludeLinkage_commentsGet {
			switch self {
			case .author: return .author
			case .commentsummary: return .commentsummary
			case .owners: return .owners
			case .reactionsummary: return .reactionsummary
			case .rootsubject: return .rootsubject
			case .subject: return .subject
			}
		}
	}

	/**
	 * enum for parameter sort
	 */
	public enum Sort_commentsGet: String, CaseIterable {
		case CreatedAtAsc = "createdAt"
		case CreatedAtDesc = "-createdAt"

		func toCommentsAPIEnum() -> CommentsAPI.Sort_commentsGet {
			switch self {
			case .CreatedAtAsc: return .CreatedAtAsc
			case .CreatedAtDesc: return .CreatedAtDesc
			}
		}
	}

	/**
     Get multiple comments.
     
     - returns: CommentsMultiResourceDataDocument
     */
	public static func commentsGet(filterSubject: String, include: [String]? = nil, includeLinkage: [CommentsAPITidal.IncludeLinkage_commentsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, sort: [CommentsAPITidal.Sort_commentsGet]? = nil) async throws -> CommentsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsGetWithRequestBuilder(filterSubject: filterSubject, include: include, includeLinkage: includeLinkage?.compactMap { $0.toCommentsAPIEnum() }, pageCursor: pageCursor, replaceMedia: replaceMedia, sort: sort?.compactMap { $0.toCommentsAPIEnum() })
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
		case commentsummary = "commentSummary"
		case owners = "owners"
		case reactionsummary = "reactionSummary"
		case rootsubject = "rootSubject"
		case subject = "subject"

		func toCommentsAPIEnum() -> CommentsAPI.IncludeLinkage_commentsIdGet {
			switch self {
			case .author: return .author
			case .commentsummary: return .commentsummary
			case .owners: return .owners
			case .reactionsummary: return .reactionsummary
			case .rootsubject: return .rootsubject
			case .subject: return .subject
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
     Get commentSummary relationship (\&quot;to-one\&quot;).
     
     - returns: CommentsCommentSummarySingleRelationshipDataDocument
     */
	public static func commentsIdRelationshipsCommentSummaryGet(id: String, include: [String]? = nil) async throws -> CommentsCommentSummarySingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdRelationshipsCommentSummaryGetWithRequestBuilder(id: id, include: include)
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
     Get reactionSummary relationship (\&quot;to-one\&quot;).
     
     - returns: CommentsReactionSummarySingleRelationshipDataDocument
     */
	public static func commentsIdRelationshipsReactionSummaryGet(id: String, include: [String]? = nil) async throws -> CommentsReactionSummarySingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdRelationshipsReactionSummaryGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get rootSubject relationship (\&quot;to-one\&quot;).
     
     - returns: CommentsRootSubjectSingleRelationshipDataDocument
     */
	public static func commentsIdRelationshipsRootSubjectGet(id: String, include: [String]? = nil) async throws -> CommentsRootSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdRelationshipsRootSubjectGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: CommentsSubjectSingleRelationshipDataDocument
     */
	public static func commentsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> CommentsSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CommentsAPI.commentsIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
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
