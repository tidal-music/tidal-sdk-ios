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
     Get single squareConnection.
     
     - returns: SquareConnectionsSingleResourceDataDocument
     */
	public static func squareConnectionsIdGet(id: String, include: [String]? = nil) async throws -> SquareConnectionsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareConnectionsAPI.squareConnectionsIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get selectedSite relationship (\&quot;to-many\&quot;).
     
     - returns: SquareConnectionsMultiRelationshipDataDocument
     */
	public static func squareConnectionsIdRelationshipsSelectedSiteGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SquareConnectionsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SquareConnectionsAPI.squareConnectionsIdRelationshipsSelectedSiteGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Update selectedSite relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func squareConnectionsIdRelationshipsSelectedSitePatch(id: String, idempotencyKey: String? = nil, squareConnectionsSelectedSiteRelationshipUpdateOperationPayload: SquareConnectionsSelectedSiteRelationshipUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			SquareConnectionsAPI.squareConnectionsIdRelationshipsSelectedSitePatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, squareConnectionsSelectedSiteRelationshipUpdateOperationPayload: squareConnectionsSelectedSiteRelationshipUpdateOperationPayload)
		}
	}


	/**
     Get sites relationship (\&quot;to-many\&quot;).
     
     - returns: SquareConnectionsMultiRelationshipDataDocument
     */
	public static func squareConnectionsIdRelationshipsSitesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SquareConnectionsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SquareConnectionsAPI.squareConnectionsIdRelationshipsSitesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single squareConnection.
     
     - returns: SquareConnectionsSingleResourceDataDocument
     */
	public static func squareConnectionsPost(countryCode: String? = nil, idempotencyKey: String? = nil, squareConnectionsCreateOperationPayload: SquareConnectionsCreateOperationPayload? = nil) async throws -> SquareConnectionsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareConnectionsAPI.squareConnectionsPostWithRequestBuilder(countryCode: countryCode, idempotencyKey: idempotencyKey, squareConnectionsCreateOperationPayload: squareConnectionsCreateOperationPayload)
		}
	}
}
