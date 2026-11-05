import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `CommentSummariesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await CommentSummariesAPITidal.getResource()
/// ```
public enum CommentSummariesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_commentSummariesGet: String, CaseIterable {
		case subject = "subject"

		func toCommentSummariesAPIEnum() -> CommentSummariesAPI.IncludeLinkage_commentSummariesGet {
			switch self {
			case .subject: return .subject
			}
		}
	}

	/**
     Get multiple commentSummaries.
     
     - returns: CommentSummariesMultiResourceDataDocument
     */
	public static func commentSummariesGet(filterSubject: [String], countryCode: String? = nil, include: [String]? = nil, includeLinkage: [CommentSummariesAPITidal.IncludeLinkage_commentSummariesGet]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> CommentSummariesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			CommentSummariesAPI.commentSummariesGetWithRequestBuilder(filterSubject: filterSubject, countryCode: countryCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toCommentSummariesAPIEnum() }, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: CommentSummariesSubjectSingleRelationshipDataDocument
     */
	public static func commentSummariesIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> CommentSummariesSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CommentSummariesAPI.commentSummariesIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}
}
