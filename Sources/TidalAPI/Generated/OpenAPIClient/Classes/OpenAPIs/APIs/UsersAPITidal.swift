import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UsersAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UsersAPITidal.getResource()
/// ```
public enum UsersAPITidal {


	/**
     Get single user.
     
     - returns: UsersSingleResourceDataDocument
     */
	public static func usersIdGet(id: String) async throws -> UsersSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UsersAPI.usersIdGetWithRequestBuilder(id: id)
		}
	}
}
