import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SavedSharesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SavedSharesAPITidal.getResource()
/// ```
public enum SavedSharesAPITidal {


	/**
     Create single savedShare.
     
     - returns: SavedSharesCreateSingleResourceDataDocument
     */
	public static func savedSharesPost(idempotencyKey: String? = nil, savedSharesCreateOperationPayload: SavedSharesCreateOperationPayload? = nil) async throws -> SavedSharesCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SavedSharesAPI.savedSharesPostWithRequestBuilder(idempotencyKey: idempotencyKey, savedSharesCreateOperationPayload: savedSharesCreateOperationPayload)
		}
	}
}
