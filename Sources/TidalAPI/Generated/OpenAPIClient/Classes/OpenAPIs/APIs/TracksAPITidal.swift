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
     Get multiple tracks.
     
     - returns: TracksMultiDataDocument
     */
	public static func tracksGet(countryCode: String, include: [String]? = nil, filterIsrc: [String]? = nil, filterId: [String]? = nil) async throws -> TracksMultiDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksGetWithRequestBuilder(countryCode: countryCode, include: include, filterIsrc: filterIsrc, filterId: filterId)
		}
	}


	/**
     Get single track.
     
     - returns: TracksSingleDataDocument
     */
	public static func tracksIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> TracksSingleDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Update single track.
     
     - returns: 
     */
	public static func tracksIdPatch(id: String, trackUpdateOperationPayload: TrackUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdPatchWithRequestBuilder(id: id, trackUpdateOperationPayload: trackUpdateOperationPayload)
		}
	}


	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiDataRelationshipDocument
     */
	public static func tracksIdRelationshipsAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiDataRelationshipDocument
     */
	public static func tracksIdRelationshipsArtistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get providers relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiDataRelationshipDocument
     */
	public static func tracksIdRelationshipsProvidersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsProvidersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get radio relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiDataRelationshipDocument
     */
	public static func tracksIdRelationshipsRadioGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsRadioGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get similarTracks relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiDataRelationshipDocument
     */
	public static func tracksIdRelationshipsSimilarTracksGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsSimilarTracksGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}
}
