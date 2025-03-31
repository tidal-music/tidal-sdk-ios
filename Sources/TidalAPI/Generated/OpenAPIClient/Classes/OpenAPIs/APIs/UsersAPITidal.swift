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
     Get multiple users.
     
     - returns: UsersMultiDataDocument
     */
	public static func usersGet(filterId: [String]? = nil) async throws -> UsersMultiDataDocument {
		return try await RequestHelper.createRequest {
			UsersAPI.usersGetWithRequestBuilder(filterId: filterId)
		}
	}


	/**
     Get single user.
     
     - returns: UsersSingleDataDocument
     */
	public static func usersIdGet(id: String) async throws -> UsersSingleDataDocument {
		return try await RequestHelper.createRequest {
			UsersAPI.usersIdGetWithRequestBuilder(id: id)
		}
	}


	/**
     Get current user&#39;s user(s).
     
     - returns: UsersSingleDataDocument
     */
	public static func usersMeGet() async throws -> UsersSingleDataDocument {
		return try await RequestHelper.createRequest {
			UsersAPI.usersMeGetWithRequestBuilder()
		}
	}
}
