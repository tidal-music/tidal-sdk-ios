import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ArtistsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtistsAPITidal.getResource()
/// ```
public enum ArtistsAPITidal {


	/**
     Get all artists
     
     - returns: ArtistsMultiDataDocument
     */
	public static func artistsGet(countryCode: String, include: [String]? = nil, filterId: [String]? = nil) async throws -> ArtistsMultiDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsGetWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId)
		}
	}


	/**
     Get single artist
     
     - returns: ArtistsSingleDataDocument
     */
	public static func artistsIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> ArtistsSingleDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Relationship: albums
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: radio
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsRadioGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsRadioGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: roles
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsRolesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsRolesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: similarArtists
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsSimilarArtistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsSimilarArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: trackProviders
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsTrackProvidersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsTrackProvidersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: tracks
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsTracksGet(id: String, countryCode: String, collapseBy: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsTracksGetWithRequestBuilder(id: id, countryCode: countryCode, collapseBy: collapseBy, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: videos
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsVideosGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsVideosGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}
}
