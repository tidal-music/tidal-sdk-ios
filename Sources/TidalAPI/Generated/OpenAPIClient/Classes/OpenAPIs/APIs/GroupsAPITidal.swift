import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `GroupsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await GroupsAPITidal.getResource()
/// ```
public enum GroupsAPITidal {


	/**
     Get multiple groups.
     
     - returns: GroupsMultiResourceDataDocument
     */
	public static func groupsGet(filterName: String) async throws -> GroupsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			GroupsAPI.groupsGetWithRequestBuilder(filterName: filterName)
		}
	}


	/**
     Get single group.
     
     - returns: GroupsSingleResourceDataDocument
     */
	public static func groupsIdGet(id: String) async throws -> GroupsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			GroupsAPI.groupsIdGetWithRequestBuilder(id: id)
		}
	}
}
