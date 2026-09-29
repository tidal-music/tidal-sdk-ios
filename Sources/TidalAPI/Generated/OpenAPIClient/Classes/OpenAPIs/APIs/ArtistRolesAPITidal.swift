import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ArtistRolesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtistRolesAPITidal.getResource()
/// ```
public enum ArtistRolesAPITidal {


	/**
     Get single artistRole.
     
     - returns: ArtistRolesSingleResourceDataDocument
     */
	public static func artistRolesIdGet(id: String) async throws -> ArtistRolesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistRolesAPI.artistRolesIdGetWithRequestBuilder(id: id)
		}
	}
}
