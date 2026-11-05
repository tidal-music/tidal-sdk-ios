import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `TrackSourceFilesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await TrackSourceFilesAPITidal.getResource()
/// ```
public enum TrackSourceFilesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_trackSourceFilesIdGet: String, CaseIterable {
		case commentsummary = "commentSummary"
		case owners = "owners"
		case reactionsummary = "reactionSummary"

		func toTrackSourceFilesAPIEnum() -> TrackSourceFilesAPI.IncludeLinkage_trackSourceFilesIdGet {
			switch self {
			case .commentsummary: return .commentsummary
			case .owners: return .owners
			case .reactionsummary: return .reactionsummary
			}
		}
	}

	/**
     Get single trackSourceFile.
     
     - returns: TrackSourceFilesSingleResourceDataDocument
     */
	public static func trackSourceFilesIdGet(id: String, include: [String]? = nil, includeLinkage: [TrackSourceFilesAPITidal.IncludeLinkage_trackSourceFilesIdGet]? = nil, shareCode: String? = nil) async throws -> TrackSourceFilesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TrackSourceFilesAPI.trackSourceFilesIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toTrackSourceFilesAPIEnum() }, shareCode: shareCode)
		}
	}


	/**
     Get commentSummary relationship (\&quot;to-one\&quot;).
     
     - returns: TrackSourceFilesCommentSummarySingleRelationshipDataDocument
     */
	public static func trackSourceFilesIdRelationshipsCommentSummaryGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> TrackSourceFilesCommentSummarySingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TrackSourceFilesAPI.trackSourceFilesIdRelationshipsCommentSummaryGetWithRequestBuilder(id: id, include: include, shareCode: shareCode)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: TrackSourceFilesOwnersMultiRelationshipDataDocument
     */
	public static func trackSourceFilesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TrackSourceFilesOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TrackSourceFilesAPI.trackSourceFilesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get reactionSummary relationship (\&quot;to-one\&quot;).
     
     - returns: TrackSourceFilesReactionSummarySingleRelationshipDataDocument
     */
	public static func trackSourceFilesIdRelationshipsReactionSummaryGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> TrackSourceFilesReactionSummarySingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TrackSourceFilesAPI.trackSourceFilesIdRelationshipsReactionSummaryGetWithRequestBuilder(id: id, include: include, shareCode: shareCode)
		}
	}


	/**
     Create single trackSourceFile.
     
     - returns: TrackSourceFilesCreateSingleResourceDataDocument
     */
	public static func trackSourceFilesPost(idempotencyKey: String? = nil, trackSourceFilesCreateOperationPayload: TrackSourceFilesCreateOperationPayload? = nil) async throws -> TrackSourceFilesCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TrackSourceFilesAPI.trackSourceFilesPostWithRequestBuilder(idempotencyKey: idempotencyKey, trackSourceFilesCreateOperationPayload: trackSourceFilesCreateOperationPayload)
		}
	}
}
