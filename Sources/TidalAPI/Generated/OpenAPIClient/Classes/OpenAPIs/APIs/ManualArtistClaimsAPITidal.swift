import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ManualArtistClaimsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ManualArtistClaimsAPITidal.getResource()
/// ```
public enum ManualArtistClaimsAPITidal {


	/**
     Create single manualArtistClaim.
     
     - returns: ManualArtistClaimsSingleResourceDataDocument
     */
	public static func manualArtistClaimsPost(manualArtistClaimsCreateOperationPayload: ManualArtistClaimsCreateOperationPayload? = nil) async throws -> ManualArtistClaimsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ManualArtistClaimsAPI.manualArtistClaimsPostWithRequestBuilder(manualArtistClaimsCreateOperationPayload: manualArtistClaimsCreateOperationPayload)
		}
	}
}
