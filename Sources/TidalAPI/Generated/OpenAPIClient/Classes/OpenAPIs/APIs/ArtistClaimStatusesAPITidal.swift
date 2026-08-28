import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ArtistClaimStatusesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtistClaimStatusesAPITidal.getResource()
/// ```
public enum ArtistClaimStatusesAPITidal {


	/**
     Get multiple artistClaimStatuses.
     
     - returns: ArtistClaimStatusesMultiResourceDataDocument
     */
	public static func artistClaimStatusesGet(filterId: [String]) async throws -> ArtistClaimStatusesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistClaimStatusesAPI.artistClaimStatusesGetWithRequestBuilder(filterId: filterId)
		}
	}
}
