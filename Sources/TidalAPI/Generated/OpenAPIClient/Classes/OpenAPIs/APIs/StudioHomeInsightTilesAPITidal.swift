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
     Get single studioHomeInsightTile.
     
     - returns: StudioHomeInsightTilesSingleResourceDataDocument
     */
	public static func studioHomeInsightTilesIdGet(id: String) async throws -> StudioHomeInsightTilesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			StudioHomeInsightTilesAPI.studioHomeInsightTilesIdGetWithRequestBuilder(id: id)
		}
	}
}
