import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ReactionSummariesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ReactionSummariesAPITidal.getResource()
/// ```
public enum ReactionSummariesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_reactionSummariesGet: String, CaseIterable {
		case subject = "subject"

		func toReactionSummariesAPIEnum() -> ReactionSummariesAPI.IncludeLinkage_reactionSummariesGet {
			switch self {
			case .subject: return .subject
			}
		}
	}

	/**
     Get multiple reactionSummaries.
     
     - returns: ReactionSummariesMultiResourceDataDocument
     */
	public static func reactionSummariesGet(filterSubject: [String], countryCode: String? = nil, include: [String]? = nil, includeLinkage: [ReactionSummariesAPITidal.IncludeLinkage_reactionSummariesGet]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> ReactionSummariesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ReactionSummariesAPI.reactionSummariesGetWithRequestBuilder(filterSubject: filterSubject, countryCode: countryCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toReactionSummariesAPIEnum() }, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: ReactionSummariesSubjectSingleRelationshipDataDocument
     */
	public static func reactionSummariesIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> ReactionSummariesSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ReactionSummariesAPI.reactionSummariesIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}
}
