import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `TemporaryUserTokensAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await TemporaryUserTokensAPITidal.getResource()
/// ```
public enum TemporaryUserTokensAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_temporaryUserTokensIdGet: String, CaseIterable {
		case owners = "owners"

		func toTemporaryUserTokensAPIEnum() -> TemporaryUserTokensAPI.IncludeLinkage_temporaryUserTokensIdGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get single temporaryUserToken.
     
     - returns: TemporaryUserTokensSingleResourceDataDocument
     */
	public static func temporaryUserTokensIdGet(id: String, include: [String]? = nil, includeLinkage: [TemporaryUserTokensAPITidal.IncludeLinkage_temporaryUserTokensIdGet]? = nil) async throws -> TemporaryUserTokensSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TemporaryUserTokensAPI.temporaryUserTokensIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toTemporaryUserTokensAPIEnum() })
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: TemporaryUserTokensOwnersMultiRelationshipDataDocument
     */
	public static func temporaryUserTokensIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TemporaryUserTokensOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TemporaryUserTokensAPI.temporaryUserTokensIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single temporaryUserToken.
     
     - returns: TemporaryUserTokensCreateSingleResourceDataDocument
     */
	public static func temporaryUserTokensPost(idempotencyKey: String? = nil, temporaryUserTokensCreateOperationPayload: TemporaryUserTokensCreateOperationPayload? = nil) async throws -> TemporaryUserTokensCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TemporaryUserTokensAPI.temporaryUserTokensPostWithRequestBuilder(idempotencyKey: idempotencyKey, temporaryUserTokensCreateOperationPayload: temporaryUserTokensCreateOperationPayload)
		}
	}
}
