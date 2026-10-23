import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SquareItemsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SquareItemsAPITidal.getResource()
/// ```
public enum SquareItemsAPITidal {


	/**
	 * enum for parameter filterOrigin
	 */
	public enum FilterOrigin_squareItemsGet: String, CaseIterable {
		case tidal = "TIDAL"
		case other = "OTHER"

		func toSquareItemsAPIEnum() -> SquareItemsAPI.FilterOrigin_squareItemsGet {
			switch self {
			case .tidal: return .tidal
			case .other: return .other
			}
		}
	}

	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_squareItemsGet: String, CaseIterable {
		case artworks = "artworks"
		case owners = "owners"
		case variations = "variations"

		func toSquareItemsAPIEnum() -> SquareItemsAPI.IncludeLinkage_squareItemsGet {
			switch self {
			case .artworks: return .artworks
			case .owners: return .owners
			case .variations: return .variations
			}
		}
	}

	/**
     Get multiple squareItems.
     
     - returns: SquareItemsMultiResourceDataDocument
     */
	public static func squareItemsGet(filterOwnersId: [String], filterOrigin: SquareItemsAPITidal.FilterOrigin_squareItemsGet? = nil, filterQuery: String? = nil, include: [String]? = nil, includeLinkage: [SquareItemsAPITidal.IncludeLinkage_squareItemsGet]? = nil, pageCursor: String? = nil) async throws -> SquareItemsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemsAPI.squareItemsGetWithRequestBuilder(filterOwnersId: filterOwnersId, filterOrigin: filterOrigin?.toSquareItemsAPIEnum(), filterQuery: filterQuery, include: include, includeLinkage: includeLinkage?.compactMap { $0.toSquareItemsAPIEnum() }, pageCursor: pageCursor)
		}
	}


	/**
     Delete single squareItem.
     
     - returns: MutationResponseDocument
     */
	public static func squareItemsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			SquareItemsAPI.squareItemsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_squareItemsIdGet: String, CaseIterable {
		case artworks = "artworks"
		case owners = "owners"
		case variations = "variations"

		func toSquareItemsAPIEnum() -> SquareItemsAPI.IncludeLinkage_squareItemsIdGet {
			switch self {
			case .artworks: return .artworks
			case .owners: return .owners
			case .variations: return .variations
			}
		}
	}

	/**
     Get single squareItem.
     
     - returns: SquareItemsSingleResourceDataDocument
     */
	public static func squareItemsIdGet(id: String, include: [String]? = nil, includeLinkage: [SquareItemsAPITidal.IncludeLinkage_squareItemsIdGet]? = nil) async throws -> SquareItemsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemsAPI.squareItemsIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toSquareItemsAPIEnum() })
		}
	}


	/**
     Update single squareItem.
     
     - returns: SquareItemsUpdateSingleResourceDataDocument
     */
	public static func squareItemsIdPatch(id: String, idempotencyKey: String, squareItemsUpdateOperationPayload: SquareItemsUpdateOperationPayload? = nil) async throws -> SquareItemsUpdateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemsAPI.squareItemsIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, squareItemsUpdateOperationPayload: squareItemsUpdateOperationPayload)
		}
	}


	/**
     Get artworks relationship (\&quot;to-many\&quot;).
     
     - returns: SquareItemsArtworksMultiRelationshipDataDocument
     */
	public static func squareItemsIdRelationshipsArtworksGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SquareItemsArtworksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemsAPI.squareItemsIdRelationshipsArtworksGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: SquareItemsOwnersMultiRelationshipDataDocument
     */
	public static func squareItemsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SquareItemsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemsAPI.squareItemsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get variations relationship (\&quot;to-many\&quot;).
     
     - returns: SquareItemsVariationsMultiRelationshipDataDocument
     */
	public static func squareItemsIdRelationshipsVariationsGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SquareItemsVariationsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemsAPI.squareItemsIdRelationshipsVariationsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Update variations relationship (\&quot;to-many\&quot;).
     
     - returns: SquareItemsVariationsUpdateMultiRelationshipDataDocument
     */
	public static func squareItemsIdRelationshipsVariationsPatch(id: String, idempotencyKey: String, squareItemsVariationsRelationshipUpdateOperationPayload: SquareItemsVariationsRelationshipUpdateOperationPayload? = nil) async throws -> SquareItemsVariationsUpdateMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemsAPI.squareItemsIdRelationshipsVariationsPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, squareItemsVariationsRelationshipUpdateOperationPayload: squareItemsVariationsRelationshipUpdateOperationPayload)
		}
	}


	/**
     Create single squareItem.
     
     - returns: SquareItemsCreateSingleResourceDataDocument
     */
	public static func squareItemsPost(idempotencyKey: String, squareItemsCreateOperationPayload: SquareItemsCreateOperationPayload? = nil) async throws -> SquareItemsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemsAPI.squareItemsPostWithRequestBuilder(idempotencyKey: idempotencyKey, squareItemsCreateOperationPayload: squareItemsCreateOperationPayload)
		}
	}
}
