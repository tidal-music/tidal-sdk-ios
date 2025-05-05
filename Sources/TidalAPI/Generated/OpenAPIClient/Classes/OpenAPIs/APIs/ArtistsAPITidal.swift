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
     Get multiple artists.
     
     - returns: ArtistsMultiDataDocument
     */
	public static func artistsGet(countryCode: String, include: [String]? = nil, filterHandle: [String]? = nil, filterId: [String]? = nil) async throws -> ArtistsMultiDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsGetWithRequestBuilder(countryCode: countryCode, include: include, filterHandle: filterHandle, filterId: filterId)
		}
	}


	/**
     Get single artist.
     
     - returns: ArtistsSingleDataDocument
     */
	public static func artistsIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> ArtistsSingleDataDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Update single artist.
     
     - returns: 
     */
	public static func artistsIdPatch(id: String, artistUpdateBody: ArtistUpdateBody? = nil) async throws {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdPatchWithRequestBuilder(id: id, artistUpdateBody: artistUpdateBody)
		}
	}


	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get profileArt relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsProfileArtGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsProfileArtGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get radio relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsRadioGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsRadioGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get roles relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsRolesGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsRolesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get similarArtists relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsSimilarArtistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsSimilarArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get trackProviders relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsTrackProvidersResourceIdentifier
     */
	public static func artistsIdRelationshipsTrackProvidersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsTrackProvidersResourceIdentifier {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsTrackProvidersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get tracks relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsTracksGet(id: String, countryCode: String, collapseBy: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsTracksGetWithRequestBuilder(id: id, countryCode: countryCode, collapseBy: collapseBy, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get videos relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistsMultiDataRelationshipDocument
     */
	public static func artistsIdRelationshipsVideosGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			ArtistsAPI.artistsIdRelationshipsVideosGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}
}
