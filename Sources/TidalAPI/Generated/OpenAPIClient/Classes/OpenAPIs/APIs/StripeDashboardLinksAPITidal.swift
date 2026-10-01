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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_stripeDashboardLinksGet: String, CaseIterable {
		case owners = "owners"

		func toStripeDashboardLinksAPIEnum() -> StripeDashboardLinksAPI.IncludeLinkage_stripeDashboardLinksGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get multiple stripeDashboardLinks.
     
     - returns: StripeDashboardLinksMultiResourceDataDocument
     */
	public static func stripeDashboardLinksGet(filterOwnersId: [String], include: [String]? = nil, includeLinkage: [StripeDashboardLinksAPITidal.IncludeLinkage_stripeDashboardLinksGet]? = nil) async throws -> StripeDashboardLinksMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			StripeDashboardLinksAPI.stripeDashboardLinksGetWithRequestBuilder(filterOwnersId: filterOwnersId, include: include, includeLinkage: includeLinkage?.compactMap { $0.toStripeDashboardLinksAPIEnum() })
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: StripeDashboardLinksOwnersMultiRelationshipDataDocument
     */
	public static func stripeDashboardLinksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> StripeDashboardLinksOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			StripeDashboardLinksAPI.stripeDashboardLinksIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
