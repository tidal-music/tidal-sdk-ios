import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ArtworksAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtworksAPITidal.getResource()
/// ```
public enum ArtworksAPITidal {


	/**
     Get multiple artworks.
     
     - returns: ArtworksMultiDataDocument
     */
	public static func artworksGet(countryCode: String, filterId: [String]? = nil) async throws -> ArtworksMultiDataDocument {
		return try await RequestHelper.createRequest {
			ArtworksAPI.artworksGetWithRequestBuilder(countryCode: countryCode, filterId: filterId)
		}
	}


	/**
     Get single artwork.
     
     - returns: ArtworksSingleDataDocument
     */
	public static func artworksIdGet(id: String, countryCode: String) async throws -> ArtworksSingleDataDocument {
		return try await RequestHelper.createRequest {
			ArtworksAPI.artworksIdGetWithRequestBuilder(id: id, countryCode: countryCode)
		}
	}


	/**
     Create single artwork.
     
     - returns: ArtworksSingleDataDocument
     */
	public static func artworksPost(artworkCreateOperationPayload: ArtworkCreateOperationPayload? = nil) async throws -> ArtworksSingleDataDocument {
		return try await RequestHelper.createRequest {
			ArtworksAPI.artworksPostWithRequestBuilder(artworkCreateOperationPayload: artworkCreateOperationPayload)
		}
	}
}
