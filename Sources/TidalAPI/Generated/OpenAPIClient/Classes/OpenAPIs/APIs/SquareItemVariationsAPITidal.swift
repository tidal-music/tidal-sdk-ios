import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SquareItemVariationsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SquareItemVariationsAPITidal.getResource()
/// ```
public enum SquareItemVariationsAPITidal {


	/**
     Commit atomic resource operations
     
     - returns: AtomicOperationsResponse
     */
	public static func operationsPost(idempotencyKey: String, atomicOperationsRequest: AtomicOperationsRequest) async throws -> AtomicOperationsResponse {
		return try await RequestHelper.createRequest {
			SquareItemVariationsAPI.operationsPostWithRequestBuilder(idempotencyKey: idempotencyKey, atomicOperationsRequest: atomicOperationsRequest)
		}
	}


	/**
     Delete single squareItemVariation.
     
     - returns: MutationResponseDocument
     */
	public static func squareItemVariationsIdDelete(id: String, idempotencyKey: String) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			SquareItemVariationsAPI.squareItemVariationsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_squareItemVariationsIdGet: String, CaseIterable {
		case owners = "owners"

		func toSquareItemVariationsAPIEnum() -> SquareItemVariationsAPI.IncludeLinkage_squareItemVariationsIdGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get single squareItemVariation.
     
     - returns: SquareItemVariationsSingleResourceDataDocument
     */
	public static func squareItemVariationsIdGet(id: String, include: [String]? = nil, includeLinkage: [SquareItemVariationsAPITidal.IncludeLinkage_squareItemVariationsIdGet]? = nil) async throws -> SquareItemVariationsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemVariationsAPI.squareItemVariationsIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toSquareItemVariationsAPIEnum() })
		}
	}


	/**
     Update single squareItemVariation.
     
     - returns: SquareItemVariationsUpdateSingleResourceDataDocument
     */
	public static func squareItemVariationsIdPatch(id: String, idempotencyKey: String, squareItemVariationsUpdateOperationPayload: SquareItemVariationsUpdateOperationPayload? = nil) async throws -> SquareItemVariationsUpdateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemVariationsAPI.squareItemVariationsIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, squareItemVariationsUpdateOperationPayload: squareItemVariationsUpdateOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: SquareItemVariationsOwnersMultiRelationshipDataDocument
     */
	public static func squareItemVariationsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SquareItemVariationsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemVariationsAPI.squareItemVariationsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single squareItemVariation.
     
     - returns: SquareItemVariationsCreateSingleResourceDataDocument
     */
	public static func squareItemVariationsPost(idempotencyKey: String, squareItemVariationsCreateOperationPayload: SquareItemVariationsCreateOperationPayload? = nil) async throws -> SquareItemVariationsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemVariationsAPI.squareItemVariationsPostWithRequestBuilder(idempotencyKey: idempotencyKey, squareItemVariationsCreateOperationPayload: squareItemVariationsCreateOperationPayload)
		}
	}
}
