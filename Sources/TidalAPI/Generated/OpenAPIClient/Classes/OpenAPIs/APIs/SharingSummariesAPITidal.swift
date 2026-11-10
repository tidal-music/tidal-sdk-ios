import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SharingSummariesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SharingSummariesAPITidal.getResource()
/// ```
public enum SharingSummariesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_sharingSummariesGet: String, CaseIterable {
		case subject = "subject"

		func toSharingSummariesAPIEnum() -> SharingSummariesAPI.IncludeLinkage_sharingSummariesGet {
			switch self {
			case .subject: return .subject
			}
		}
	}

	/**
     Get multiple sharingSummaries.
     
     - returns: SharingSummariesMultiResourceDataDocument
     */
	public static func sharingSummariesGet(filterSubject: [String], include: [String]? = nil, includeLinkage: [SharingSummariesAPITidal.IncludeLinkage_sharingSummariesGet]? = nil, replaceMedia: String? = nil) async throws -> SharingSummariesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			SharingSummariesAPI.sharingSummariesGetWithRequestBuilder(filterSubject: filterSubject, include: include, includeLinkage: includeLinkage?.compactMap { $0.toSharingSummariesAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: SharingSummariesSubjectSingleRelationshipDataDocument
     */
	public static func sharingSummariesIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> SharingSummariesSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SharingSummariesAPI.sharingSummariesIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}
}
