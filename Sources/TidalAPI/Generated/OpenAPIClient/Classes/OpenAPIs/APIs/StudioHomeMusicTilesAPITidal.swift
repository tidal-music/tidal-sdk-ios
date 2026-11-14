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
     Get single studioHomeMusicTile.
     
     - returns: StudioHomeMusicTilesSingleResourceDataDocument
     */
	public static func studioHomeMusicTilesIdGet(id: String) async throws -> StudioHomeMusicTilesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			StudioHomeMusicTilesAPI.studioHomeMusicTilesIdGetWithRequestBuilder(id: id)
		}
	}
}
