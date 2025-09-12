import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `AppreciationsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await AppreciationsAPITidal.getResource()
/// ```
public enum AppreciationsAPITidal {


	/**
     Create single appreciation.
     
     - returns: AppreciationsSingleResourceDataDocument
     */
	public static func appreciationsPost(appreciationsCreateOperationPayload: AppreciationsCreateOperationPayload? = nil) async throws -> AppreciationsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			AppreciationsAPI.appreciationsPostWithRequestBuilder(appreciationsCreateOperationPayload: appreciationsCreateOperationPayload)
		}
	}
}
