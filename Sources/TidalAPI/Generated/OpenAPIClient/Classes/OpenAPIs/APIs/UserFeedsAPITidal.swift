import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserFeedsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserFeedsAPITidal.getResource()
/// ```
public enum UserFeedsAPITidal {


	/**
     Get single userFeed.
     
     - returns: UserFeedsSingleResourceDataDocument
     */
	public static func userFeedsIdGet(id: String) async throws -> UserFeedsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserFeedsAPI.userFeedsIdGetWithRequestBuilder(id: id)
		}
	}


	/**
     Update single userFeed.
     
     - returns: UserFeedsUpdateSingleResourceDataDocument
     */
	public static func userFeedsIdPatch(id: String, idempotencyKey: String? = nil, userFeedsUpdateOperationPayload: UserFeedsUpdateOperationPayload? = nil) async throws -> UserFeedsUpdateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserFeedsAPI.userFeedsIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, userFeedsUpdateOperationPayload: userFeedsUpdateOperationPayload)
		}
	}
}
