import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `StripeDashboardLinksAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await StripeDashboardLinksAPITidal.getResource()
/// ```
public enum StripeDashboardLinksAPITidal {


	/**
     Get multiple stripeDashboardLinks.
     
     - returns: StripeDashboardLinksMultiResourceDataDocument
     */
	public static func stripeDashboardLinksGet(filterOwnersId: [String], include: [String]? = nil) async throws -> StripeDashboardLinksMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			StripeDashboardLinksAPI.stripeDashboardLinksGetWithRequestBuilder(filterOwnersId: filterOwnersId, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: StripeDashboardLinksMultiRelationshipDataDocument
     */
	public static func stripeDashboardLinksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> StripeDashboardLinksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			StripeDashboardLinksAPI.stripeDashboardLinksIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
