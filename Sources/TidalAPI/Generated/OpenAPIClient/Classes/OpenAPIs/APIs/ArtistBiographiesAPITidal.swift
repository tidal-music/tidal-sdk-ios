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
     
     - returns: ArtistBiographiesMultiDataDocument
     */
	public static func artistBiographiesGet(countryCode: String, include: [String]? = nil, filterId: [String]? = nil) async throws -> ArtistBiographiesMultiDataDocument {
		return try await RequestHelper.createRequest {
			ArtistBiographiesAPI.artistBiographiesGetWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId)
		}
	}


	/**
     Get single artistBiographie.
     
     - returns: ArtistBiographiesSingleDataDocument
     */
	public static func artistBiographiesIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> ArtistBiographiesSingleDataDocument {
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
     
     - returns: ArtistBiographiesMultiDataRelationshipDocument
     */
	public static func artistBiographiesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistBiographiesMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistBiographiesAPI.artistBiographiesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
