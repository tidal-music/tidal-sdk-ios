import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `StudioHomeEventTilesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await StudioHomeEventTilesAPITidal.getResource()
/// ```
public enum StudioHomeEventTilesAPITidal {


	/**
     Get single studioHomeEventTile.
     
     - returns: StudioHomeEventTilesSingleResourceDataDocument
     */
	public static func studioHomeEventTilesIdGet(id: String) async throws -> StudioHomeEventTilesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			StudioHomeEventTilesAPI.studioHomeEventTilesIdGetWithRequestBuilder(id: id)
		}
	}
}
