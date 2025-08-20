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
     
     - returns: ArtworksMultiResourceDataDocument
     */
	public static func artworksGet(countryCode: String, include: [String]? = nil, filterId: [String]? = nil) async throws -> ArtworksMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtworksAPI.artworksGetWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId)
		}
	}


	/**
     Get single artwork.
     
     - returns: ArtworksSingleResourceDataDocument
     */
	public static func artworksIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> ArtworksSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtworksAPI.artworksIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ArtworksMultiRelationshipDataDocument
     */
	public static func artworksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtworksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtworksAPI.artworksIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single artwork.
     
     - returns: ArtworksSingleResourceDataDocument
     */
	public static func artworksPost(artworkCreateOperationPayload: ArtworkCreateOperationPayload? = nil) async throws -> ArtworksSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtworksAPI.artworksPostWithRequestBuilder(artworkCreateOperationPayload: artworkCreateOperationPayload)
		}
	}
}
