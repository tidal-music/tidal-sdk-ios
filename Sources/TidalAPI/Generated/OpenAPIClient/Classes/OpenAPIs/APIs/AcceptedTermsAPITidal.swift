import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `AcceptedTermsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await AcceptedTermsAPITidal.getResource()
/// ```
public enum AcceptedTermsAPITidal {


	/**
	 * enum for parameter filterTermsType
	 */
	public enum FilterTermsType_acceptedTermsGet: String, CaseIterable {
		case developer = "DEVELOPER"

		func toAcceptedTermsAPIEnum() -> AcceptedTermsAPI.FilterTermsType_acceptedTermsGet {
			switch self {
			case .developer: return .developer
			}
		}
	}

	/**
     Get multiple acceptedTerms.
     
     - returns: AcceptedTermsMultiResourceDataDocument
     */
	public static func acceptedTermsGet(include: [String]? = nil, filterLatestVersion: [String]? = nil, filterOwnersId: [String]? = nil, filterTermsType: [AcceptedTermsAPITidal.FilterTermsType_acceptedTermsGet]? = nil) async throws -> AcceptedTermsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			AcceptedTermsAPI.acceptedTermsGetWithRequestBuilder(include: include, filterLatestVersion: filterLatestVersion, filterOwnersId: filterOwnersId, filterTermsType: filterTermsType?.compactMap { $0.toAcceptedTermsAPIEnum() })
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: AcceptedTermsMultiRelationshipDataDocument
     */
	public static func acceptedTermsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AcceptedTermsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AcceptedTermsAPI.acceptedTermsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single acceptedTerm.
     
     - returns: AcceptedTermsSingleResourceDataDocument
     */
	public static func acceptedTermsPost(idempotencyKey: String? = nil, acceptedTermsCreateOperationPayload: AcceptedTermsCreateOperationPayload? = nil) async throws -> AcceptedTermsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			AcceptedTermsAPI.acceptedTermsPostWithRequestBuilder(idempotencyKey: idempotencyKey, acceptedTermsCreateOperationPayload: acceptedTermsCreateOperationPayload)
		}
	}
}
