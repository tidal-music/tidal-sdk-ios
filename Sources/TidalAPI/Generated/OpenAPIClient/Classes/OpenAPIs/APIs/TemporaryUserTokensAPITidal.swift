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
     Get single temporaryUserToken.
     
     - returns: TemporaryUserTokensSingleResourceDataDocument
     */
	public static func temporaryUserTokensIdGet(id: String, include: [String]? = nil) async throws -> TemporaryUserTokensSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TemporaryUserTokensAPI.temporaryUserTokensIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: TemporaryUserTokensMultiRelationshipDataDocument
     */
	public static func temporaryUserTokensIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TemporaryUserTokensMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TemporaryUserTokensAPI.temporaryUserTokensIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single temporaryUserToken.
     
     - returns: TemporaryUserTokensSingleResourceDataDocument
     */
	public static func temporaryUserTokensPost(idempotencyKey: String? = nil, temporaryUserTokensCreateOperationPayload: TemporaryUserTokensCreateOperationPayload? = nil) async throws -> TemporaryUserTokensSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TemporaryUserTokensAPI.temporaryUserTokensPostWithRequestBuilder(idempotencyKey: idempotencyKey, temporaryUserTokensCreateOperationPayload: temporaryUserTokensCreateOperationPayload)
		}
	}
}
