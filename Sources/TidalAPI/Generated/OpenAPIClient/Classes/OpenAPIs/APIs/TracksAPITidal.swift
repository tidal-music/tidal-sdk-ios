import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `TracksAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await TracksAPITidal.getResource()
/// ```
public enum TracksAPITidal {


	/**
     Get all tracks
     
     - returns: TracksMultiDataDocument
     */
	public static func tracksGet(countryCode: String, include: [String]? = nil, filterIsrc: [String]? = nil, filterId: [String]? = nil) async throws -> TracksMultiDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksGetWithRequestBuilder(countryCode: countryCode, include: include, filterIsrc: filterIsrc, filterId: filterId)
		}
	}


	/**
     Get single track
     
     - returns: TracksSingleDataDocument
     */
	public static func tracksIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> TracksSingleDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Relationship: albums
     
     - returns: TracksMultiDataRelationshipDocument
     */
	public static func tracksIdRelationshipsAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: artists
     
     - returns: TracksMultiDataRelationshipDocument
     */
	public static func tracksIdRelationshipsArtistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: providers
     
     - returns: TracksMultiDataRelationshipDocument
     */
	public static func tracksIdRelationshipsProvidersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsProvidersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: radio
     
     - returns: TracksMultiDataRelationshipDocument
     */
	public static func tracksIdRelationshipsRadioGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsRadioGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: similarTracks
     
     - returns: TracksMultiDataRelationshipDocument
     */
	public static func tracksIdRelationshipsSimilarTracksGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsSimilarTracksGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}
}
