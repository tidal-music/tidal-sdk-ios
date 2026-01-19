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
	public static func tracksGet(pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, filterId: [String]? = nil, filterIsrc: [String]? = nil, filterOwnersId: [String]? = nil, shareCode: String? = nil) async throws -> TracksMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksGetWithRequestBuilder(pageCursor: pageCursor, countryCode: countryCode, include: include, filterId: filterId, filterIsrc: filterIsrc, filterOwnersId: filterOwnersId, shareCode: shareCode)
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
	public static func tracksIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, shareCode: shareCode)
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
	public static func tracksIdRelationshipsAlbumsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Update albums relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func tracksIdRelationshipsAlbumsPatch(id: String, trackAlbumsRelationshipUpdateOperationPayload: TrackAlbumsRelationshipUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsAlbumsPatchWithRequestBuilder(id: id, trackAlbumsRelationshipUpdateOperationPayload: trackAlbumsRelationshipUpdateOperationPayload)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsArtistsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsArtistsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, shareCode: shareCode)
		}
	}


	/**
     Get credits relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsCreditsGet(id: String, pageCursor: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsCreditsGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include, shareCode: shareCode)
		}
	}


	/**
     Get genres relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsGenresGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsGenresGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get lyrics relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsLyricsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsLyricsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get providers relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsProvidersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsProvidersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get radio relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsRadioGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsRadioGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get replacement relationship (\&quot;to-one\&quot;).
     
     - returns: TracksSingleRelationshipDataDocument
     */
	public static func tracksIdRelationshipsReplacementGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsReplacementGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, shareCode: shareCode)
		}
	}


	/**
     Get shares relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsSharesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsSharesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get similarTracks relationship (\&quot;to-many\&quot;).
     
     - returns: TracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsSimilarTracksGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsSimilarTracksGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, shareCode: shareCode)
		}
	}


	/**
     Get sourceFile relationship (\&quot;to-one\&quot;).
     
     - returns: TracksSingleRelationshipDataDocument
     */
	public static func tracksIdRelationshipsSourceFileGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsSourceFileGetWithRequestBuilder(id: id, include: include, shareCode: shareCode)
		}
	}


	/**
     Get trackStatistics relationship (\&quot;to-one\&quot;).
     
     - returns: TracksSingleRelationshipDataDocument
     */
	public static func tracksIdRelationshipsTrackStatisticsGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsTrackStatisticsGetWithRequestBuilder(id: id, include: include, shareCode: shareCode)
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
