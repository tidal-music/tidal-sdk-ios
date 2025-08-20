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
     Get multiple artistRoles.
     
     - returns: ArtistRolesMultiResourceDataDocument
     */
	public static func artistRolesGet(filterId: [String]? = nil) async throws -> ArtistRolesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistRolesAPI.artistRolesGetWithRequestBuilder(filterId: filterId)
		}
	}


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
