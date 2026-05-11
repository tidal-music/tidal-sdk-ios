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
	public static func squareConnectionsIdGet(id: String) async throws -> SquareConnectionsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SquareConnectionsAPI.squareConnectionsIdGetWithRequestBuilder(id: id)
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
