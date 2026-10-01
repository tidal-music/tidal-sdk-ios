import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ViewerContextsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ViewerContextsAPITidal.getResource()
/// ```
public enum ViewerContextsAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_viewerContextsGet: String, CaseIterable {
		case subject = "subject"
		case viewer = "viewer"

		func toViewerContextsAPIEnum() -> ViewerContextsAPI.IncludeLinkage_viewerContextsGet {
			switch self {
			case .subject: return .subject
			case .viewer: return .viewer
			}
		}
	}

	/**
     Get multiple viewerContexts.
     
     - returns: ViewerContextsMultiResourceDataDocument
     */
	public static func viewerContextsGet(filterSubject: [String], include: [String]? = nil, includeLinkage: [ViewerContextsAPITidal.IncludeLinkage_viewerContextsGet]? = nil, replaceMedia: String? = nil) async throws -> ViewerContextsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ViewerContextsAPI.viewerContextsGetWithRequestBuilder(filterSubject: filterSubject, include: include, includeLinkage: includeLinkage?.compactMap { $0.toViewerContextsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_viewerContextsIdGet: String, CaseIterable {
		case subject = "subject"
		case viewer = "viewer"

		func toViewerContextsAPIEnum() -> ViewerContextsAPI.IncludeLinkage_viewerContextsIdGet {
			switch self {
			case .subject: return .subject
			case .viewer: return .viewer
			}
		}
	}

	/**
     Get single viewerContext.
     
     - returns: ViewerContextsSingleResourceDataDocument
     */
	public static func viewerContextsIdGet(id: String, include: [String]? = nil, includeLinkage: [ViewerContextsAPITidal.IncludeLinkage_viewerContextsIdGet]? = nil, replaceMedia: String? = nil) async throws -> ViewerContextsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ViewerContextsAPI.viewerContextsIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toViewerContextsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: ViewerContextsSubjectSingleRelationshipDataDocument
     */
	public static func viewerContextsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ViewerContextsSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ViewerContextsAPI.viewerContextsIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get viewer relationship (\&quot;to-one\&quot;).
     
     - returns: ViewerContextsViewerSingleRelationshipDataDocument
     */
	public static func viewerContextsIdRelationshipsViewerGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ViewerContextsViewerSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ViewerContextsAPI.viewerContextsIdRelationshipsViewerGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}
}
