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
     
     - returns: TracksMultiResourceDataDocument
     */
	public static func tracksGet(countryCode: String, pageCursor: String? = nil, include: [String]? = nil, filterOwnersId: [String]? = nil, filterIsrc: [String]? = nil, filterId: [String]? = nil) async throws -> TracksMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksGetWithRequestBuilder(countryCode: countryCode, pageCursor: pageCursor, include: include, filterOwnersId: filterOwnersId, filterIsrc: filterIsrc, filterId: filterId)
		}
	}


	/**
     Delete single track.
     
     - returns: 
     */
	public static func tracksIdDelete(id: String) async throws {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdDeleteWithRequestBuilder(id: id)
		}
	}


	/**
     Get single track.
     
     - returns: TracksSingleResourceDataDocument
     */
	public static func tracksIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> TracksSingleResourceDataDocument {
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
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsArtistsGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Get genres relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsGenresGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsGenresGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get lyrics relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsLyricsGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsLyricsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get providers relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsProvidersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsProvidersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get radio relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsRadioGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsRadioGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get similarTracks relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsSimilarTracksGet(id: String, countryCode: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsSimilarTracksGetWithRequestBuilder(id: id, countryCode: countryCode, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Get sourceFile relationship (\&quot;to-one\&quot;).
     
     - returns: TracksSingleRelationshipDataDocument
     */
	public static func tracksIdRelationshipsSourceFileGet(id: String, include: [String]? = nil) async throws -> TracksSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsSourceFileGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get trackStatistics relationship (\&quot;to-one\&quot;).
     
     - returns: TracksSingleRelationshipDataDocument
     */
	public static func tracksIdRelationshipsTrackStatisticsGet(id: String, include: [String]? = nil) async throws -> TracksSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsTrackStatisticsGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Create single track.
     
     - returns: TracksSingleResourceDataDocument
     */
	public static func tracksPost(trackCreateOperationPayload: TrackCreateOperationPayload? = nil) async throws -> TracksSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksPostWithRequestBuilder(trackCreateOperationPayload: trackCreateOperationPayload)
		}
	}
}
