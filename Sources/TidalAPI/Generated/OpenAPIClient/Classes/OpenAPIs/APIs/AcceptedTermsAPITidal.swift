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
	 * enum for parameter filterTermsTermsType
	 */
	public enum FilterTermsTermsType_acceptedTermsGet: String, CaseIterable {
		case developer = "DEVELOPER"
		case uploadMarketplace = "UPLOAD_MARKETPLACE"
		case merchGuidelines = "MERCH_GUIDELINES"

		func toAcceptedTermsAPIEnum() -> AcceptedTermsAPI.FilterTermsTermsType_acceptedTermsGet {
			switch self {
			case .developer: return .developer
			case .uploadMarketplace: return .uploadMarketplace
			case .merchGuidelines: return .merchGuidelines
			}
		}
	}

	/**
     Get multiple acceptedTerms.
     
     - returns: AcceptedTermsMultiResourceDataDocument
     */
	public static func acceptedTermsGet(filterOwnersId: [String], filterTermsTermsType: [AcceptedTermsAPITidal.FilterTermsTermsType_acceptedTermsGet], include: [String]? = nil, filterTermsIsLatestVersion: [String]? = nil) async throws -> AcceptedTermsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			AcceptedTermsAPI.acceptedTermsGetWithRequestBuilder(filterOwnersId: filterOwnersId, filterTermsTermsType: filterTermsTermsType.compactMap { $0.toAcceptedTermsAPIEnum() }, include: include, filterTermsIsLatestVersion: filterTermsIsLatestVersion)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: AcceptedTermsOwnersMultiRelationshipDataDocument
     */
	public static func acceptedTermsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AcceptedTermsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AcceptedTermsAPI.acceptedTermsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get terms relationship (\&quot;to-one\&quot;).
     
     - returns: AcceptedTermsTermsSingleRelationshipDataDocument
     */
	public static func acceptedTermsIdRelationshipsTermsGet(id: String, include: [String]? = nil) async throws -> AcceptedTermsTermsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AcceptedTermsAPI.acceptedTermsIdRelationshipsTermsGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Create single acceptedTerm.
     
     - returns: AcceptedTermsCreateSingleResourceDataDocument
     */
	public static func acceptedTermsPost(idempotencyKey: String? = nil, acceptedTermsCreateOperationPayload: AcceptedTermsCreateOperationPayload? = nil) async throws -> AcceptedTermsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			AcceptedTermsAPI.acceptedTermsPostWithRequestBuilder(idempotencyKey: idempotencyKey, acceptedTermsCreateOperationPayload: acceptedTermsCreateOperationPayload)
		}
	}
}
