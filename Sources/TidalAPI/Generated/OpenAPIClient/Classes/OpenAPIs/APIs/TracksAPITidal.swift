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
     Relationship: albums
     
     - returns: AlbumsRelationshipDocument
     */
	public static func getTrackAlbumsRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumsRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.getTrackAlbumsRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: artists
     
     - returns: ArtistsRelationshipDocument
     */
	public static func getTrackArtistsRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistsRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.getTrackArtistsRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get single track
     
     - returns: TracksSingleDataDocument
     */
	public static func getTrackById(id: String, countryCode: String, include: [String]? = nil) async throws -> TracksSingleDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.getTrackByIdWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Relationship: providers
     
     - returns: ProvidersRelationshipDocument
     */
	public static func getTrackProvidersRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ProvidersRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.getTrackProvidersRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: radio
     
     - returns: TracksRelationshipsDocument
     */
	public static func getTrackRadioRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksRelationshipsDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.getTrackRadioRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: similar tracks
     
     - returns: TracksRelationshipsDocument
     */
	public static func getTrackSimilarTracksRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksRelationshipsDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.getTrackSimilarTracksRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get multiple tracks
     
     - returns: TracksMultiDataDocument
     */
	public static func getTracksByFilters(countryCode: String, include: [String]? = nil, filterId: [String]? = nil, filterIsrc: [String]? = nil) async throws -> TracksMultiDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.getTracksByFiltersWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId, filterIsrc: filterIsrc)
		}
	}
}
