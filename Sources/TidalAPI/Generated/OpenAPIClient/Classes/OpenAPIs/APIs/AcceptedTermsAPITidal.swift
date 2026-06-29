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

		func toAcceptedTermsAPIEnum() -> AcceptedTermsAPI.FilterTermsTermsType_acceptedTermsGet {
			switch self {
			case .developer: return .developer
			case .uploadMarketplace: return .uploadMarketplace
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
     
     - returns: AcceptedTermsMultiRelationshipDataDocument
     */
	public static func acceptedTermsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AcceptedTermsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AcceptedTermsAPI.acceptedTermsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get terms relationship (\&quot;to-one\&quot;).
     
     - returns: AcceptedTermsSingleRelationshipDataDocument
     */
	public static func acceptedTermsIdRelationshipsTermsGet(id: String, include: [String]? = nil) async throws -> AcceptedTermsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AcceptedTermsAPI.acceptedTermsIdRelationshipsTermsGetWithRequestBuilder(id: id, include: include)
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
