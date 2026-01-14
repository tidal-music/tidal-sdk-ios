import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ArtistBiographiesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtistBiographiesAPITidal.getResource()
/// ```
public enum ArtistBiographiesAPITidal {


	/**
     Get multiple artistBiographies.
     
     - returns: ArtistBiographiesMultiResourceDataDocument
     */
	public static func artistBiographiesGet(countryCode: String? = nil, include: [String]? = nil, filterId: [String]? = nil) async throws -> ArtistBiographiesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistBiographiesAPI.artistBiographiesGetWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId)
		}
	}


	/**
     Get single artistBiographie.
     
     - returns: ArtistBiographiesSingleResourceDataDocument
     */
	public static func artistBiographiesIdGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> ArtistBiographiesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistBiographiesAPI.artistBiographiesIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Update single artistBiographie.
     
     - returns: 
     */
	public static func artistBiographiesIdPatch(id: String, artistBiographyUpdateBody: ArtistBiographyUpdateBody? = nil) async throws {
		return try await RequestHelper.createRequest {
			ArtistBiographiesAPI.artistBiographiesIdPatchWithRequestBuilder(id: id, artistBiographyUpdateBody: artistBiographyUpdateBody)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistBiographiesMultiRelationshipDataDocument
     */
	public static func artistBiographiesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistBiographiesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistBiographiesAPI.artistBiographiesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
