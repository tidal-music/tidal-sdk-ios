import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SquareItemVariationPhysicalCountsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SquareItemVariationPhysicalCountsAPITidal.getResource()
/// ```
public enum SquareItemVariationPhysicalCountsAPITidal {


	/**
     Create single squareItemVariationPhysicalCount.
     
     - returns: SquareItemVariationPhysicalCountsCreateSingleResourceDataDocument
     */
	public static func squareItemVariationPhysicalCountsPost(idempotencyKey: String, squareItemVariationPhysicalCountsCreateOperationPayload: SquareItemVariationPhysicalCountsCreateOperationPayload? = nil) async throws -> SquareItemVariationPhysicalCountsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareItemVariationPhysicalCountsAPI.squareItemVariationPhysicalCountsPostWithRequestBuilder(idempotencyKey: idempotencyKey, squareItemVariationPhysicalCountsCreateOperationPayload: squareItemVariationPhysicalCountsCreateOperationPayload)
		}
	}
}
