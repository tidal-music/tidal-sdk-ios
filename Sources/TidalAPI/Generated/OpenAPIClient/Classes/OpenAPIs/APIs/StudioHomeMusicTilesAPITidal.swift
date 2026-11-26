import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `StudioHomeMusicTilesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await StudioHomeMusicTilesAPITidal.getResource()
/// ```
public enum StudioHomeMusicTilesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_studioHomeMusicTilesIdGet: String, CaseIterable {
		case items = "items"

		func toStudioHomeMusicTilesAPIEnum() -> StudioHomeMusicTilesAPI.IncludeLinkage_studioHomeMusicTilesIdGet {
			switch self {
			case .items: return .items
			}
		}
	}

	/**
     Get single studioHomeMusicTile.
     
     - returns: StudioHomeMusicTilesSingleResourceDataDocument
     */
	public static func studioHomeMusicTilesIdGet(id: String, include: [String]? = nil, includeLinkage: [StudioHomeMusicTilesAPITidal.IncludeLinkage_studioHomeMusicTilesIdGet]? = nil, replaceMedia: String? = nil) async throws -> StudioHomeMusicTilesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			StudioHomeMusicTilesAPI.studioHomeMusicTilesIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toStudioHomeMusicTilesAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: StudioHomeMusicTilesItemsMultiRelationshipDataDocument
     */
	public static func studioHomeMusicTilesIdRelationshipsItemsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> StudioHomeMusicTilesItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			StudioHomeMusicTilesAPI.studioHomeMusicTilesIdRelationshipsItemsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}
}
