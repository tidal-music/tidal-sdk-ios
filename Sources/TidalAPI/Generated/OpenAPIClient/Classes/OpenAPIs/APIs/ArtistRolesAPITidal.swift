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
     Get all artistRoles
     
     - returns: ArtistRolesMultiDataDocument
     */
	public static func artistRolesGet(filterId: [String]? = nil) async throws -> ArtistRolesMultiDataDocument {
		return try await RequestHelper.createRequest {
			ArtistRolesAPI.artistRolesGetWithRequestBuilder(filterId: filterId)
		}
	}


	/**
     Get single artistRole
     
     - returns: ArtistRolesSingleDataDocument
     */
	public static func artistRolesIdGet(id: String) async throws -> ArtistRolesSingleDataDocument {
		return try await RequestHelper.createRequest {
			ArtistRolesAPI.artistRolesIdGetWithRequestBuilder(id: id)
		}
	}
}
