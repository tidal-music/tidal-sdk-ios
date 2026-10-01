import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SquareConnectionsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SquareConnectionsAPITidal.getResource()
/// ```
public enum SquareConnectionsAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_squareConnectionsIdGet: String, CaseIterable {
		case selectedsite = "selectedSite"
		case sites = "sites"

		func toSquareConnectionsAPIEnum() -> SquareConnectionsAPI.IncludeLinkage_squareConnectionsIdGet {
			switch self {
			case .selectedsite: return .selectedsite
			case .sites: return .sites
			}
		}
	}

	/**
     Get single squareConnection.
     
     - returns: SquareConnectionsSingleResourceDataDocument
     */
	public static func squareConnectionsIdGet(id: String, include: [String]? = nil, includeLinkage: [SquareConnectionsAPITidal.IncludeLinkage_squareConnectionsIdGet]? = nil) async throws -> SquareConnectionsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareConnectionsAPI.squareConnectionsIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toSquareConnectionsAPIEnum() })
		}
	}


	/**
     Get selectedSite relationship (\&quot;to-one\&quot;).
     
     - returns: SquareConnectionsSelectedSiteSingleRelationshipDataDocument
     */
	public static func squareConnectionsIdRelationshipsSelectedSiteGet(id: String, include: [String]? = nil) async throws -> SquareConnectionsSelectedSiteSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SquareConnectionsAPI.squareConnectionsIdRelationshipsSelectedSiteGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Update selectedSite relationship (\&quot;to-one\&quot;).
     
     - returns: SquareConnectionsSelectedSiteUpdateSingleRelationshipDataDocument
     */
	public static func squareConnectionsIdRelationshipsSelectedSitePatch(id: String, idempotencyKey: String? = nil, squareConnectionsSelectedSiteRelationshipUpdateOperationPayload: SquareConnectionsSelectedSiteRelationshipUpdateOperationPayload? = nil) async throws -> SquareConnectionsSelectedSiteUpdateSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SquareConnectionsAPI.squareConnectionsIdRelationshipsSelectedSitePatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, squareConnectionsSelectedSiteRelationshipUpdateOperationPayload: squareConnectionsSelectedSiteRelationshipUpdateOperationPayload)
		}
	}


	/**
     Get sites relationship (\&quot;to-many\&quot;).
     
     - returns: SquareConnectionsSitesMultiRelationshipDataDocument
     */
	public static func squareConnectionsIdRelationshipsSitesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SquareConnectionsSitesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SquareConnectionsAPI.squareConnectionsIdRelationshipsSitesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single squareConnection.
     
     - returns: SquareConnectionsCreateSingleResourceDataDocument
     */
	public static func squareConnectionsPost(idempotencyKey: String? = nil, squareConnectionsCreateOperationPayload: SquareConnectionsCreateOperationPayload? = nil) async throws -> SquareConnectionsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareConnectionsAPI.squareConnectionsPostWithRequestBuilder(idempotencyKey: idempotencyKey, squareConnectionsCreateOperationPayload: squareConnectionsCreateOperationPayload)
		}
	}
}
