import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `StudioHomeInsightTilesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await StudioHomeInsightTilesAPITidal.getResource()
/// ```
public enum StudioHomeInsightTilesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_studioHomeInsightTilesIdGet: String, CaseIterable {
		case items = "items"

		func toStudioHomeInsightTilesAPIEnum() -> StudioHomeInsightTilesAPI.IncludeLinkage_studioHomeInsightTilesIdGet {
			switch self {
			case .items: return .items
			}
		}
	}

	/**
     Get single studioHomeInsightTile.
     
     - returns: StudioHomeInsightTilesSingleResourceDataDocument
     */
	public static func studioHomeInsightTilesIdGet(id: String, include: [String]? = nil, includeLinkage: [StudioHomeInsightTilesAPITidal.IncludeLinkage_studioHomeInsightTilesIdGet]? = nil, replaceMedia: String? = nil) async throws -> StudioHomeInsightTilesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			StudioHomeInsightTilesAPI.studioHomeInsightTilesIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toStudioHomeInsightTilesAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: StudioHomeInsightTilesItemsMultiRelationshipDataDocument
     */
	public static func studioHomeInsightTilesIdRelationshipsItemsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> StudioHomeInsightTilesItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			StudioHomeInsightTilesAPI.studioHomeInsightTilesIdRelationshipsItemsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}
}
