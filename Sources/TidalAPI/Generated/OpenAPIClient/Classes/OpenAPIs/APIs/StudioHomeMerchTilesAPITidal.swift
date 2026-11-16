import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `StudioHomeMerchTilesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await StudioHomeMerchTilesAPITidal.getResource()
/// ```
public enum StudioHomeMerchTilesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_studioHomeMerchTilesIdGet: String, CaseIterable {
		case items = "items"

		func toStudioHomeMerchTilesAPIEnum() -> StudioHomeMerchTilesAPI.IncludeLinkage_studioHomeMerchTilesIdGet {
			switch self {
			case .items: return .items
			}
		}
	}

	/**
     Get single studioHomeMerchTile.
     
     - returns: StudioHomeMerchTilesSingleResourceDataDocument
     */
	public static func studioHomeMerchTilesIdGet(id: String, include: [String]? = nil, includeLinkage: [StudioHomeMerchTilesAPITidal.IncludeLinkage_studioHomeMerchTilesIdGet]? = nil) async throws -> StudioHomeMerchTilesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			StudioHomeMerchTilesAPI.studioHomeMerchTilesIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toStudioHomeMerchTilesAPIEnum() })
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: StudioHomeMerchTilesItemsMultiRelationshipDataDocument
     */
	public static func studioHomeMerchTilesIdRelationshipsItemsGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> StudioHomeMerchTilesItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			StudioHomeMerchTilesAPI.studioHomeMerchTilesIdRelationshipsItemsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
