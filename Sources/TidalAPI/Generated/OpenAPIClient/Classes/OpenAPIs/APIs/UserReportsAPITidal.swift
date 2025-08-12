import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserReportsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserReportsAPITidal.getResource()
/// ```
public enum UserReportsAPITidal {

	/**
     Create single userReport.
     
     - returns: UserReportsSingleResourceDataDocument
     */
	public static func userReportsPost(userReportCreateOperationPayload: UserReportCreateOperationPayload? = nil) async throws -> UserReportsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserReportsAPI.userReportsPostWithRequestBuilder(userReportCreateOperationPayload: userReportCreateOperationPayload)
		}
	}
}
