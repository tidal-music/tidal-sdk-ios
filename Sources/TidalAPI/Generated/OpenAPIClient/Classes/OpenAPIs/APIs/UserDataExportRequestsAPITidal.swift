import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserDataExportRequestsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserDataExportRequestsAPITidal.getResource()
/// ```
public enum UserDataExportRequestsAPITidal {


	/**
     Create single userDataExportRequest.
     
     - returns: UserDataExportRequestsSingleResourceDataDocument
     */
	public static func userDataExportRequestsPost(idempotencyKey: String? = nil, userDataExportRequestsCreateOperationPayload: UserDataExportRequestsCreateOperationPayload? = nil) async throws -> UserDataExportRequestsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserDataExportRequestsAPI.userDataExportRequestsPostWithRequestBuilder(idempotencyKey: idempotencyKey, userDataExportRequestsCreateOperationPayload: userDataExportRequestsCreateOperationPayload)
		}
	}
}
