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
	 * enum for parameter sort
	 */
	public enum Sort_tracksGet: String, CaseIterable {
		case CreatedAtAsc = "createdAt"
		case CreatedAtDesc = "-createdAt"
		case TitleAsc = "title"
		case TitleDesc = "-title"

		func toTracksAPIEnum() -> TracksAPI.Sort_tracksGet {
			switch self {
			case .CreatedAtAsc: return .CreatedAtAsc
			case .CreatedAtDesc: return .CreatedAtDesc
			case .TitleAsc: return .TitleAsc
			case .TitleDesc: return .TitleDesc
			}
		}
	}

	/**
     Get multiple tracks.
     
     - returns: TracksMultiResourceDataDocument
     */
	public static func tracksGet(pageCursor: String? = nil, sort: [TracksAPITidal.Sort_tracksGet]? = nil, countryCode: String? = nil, include: [String]? = nil, filterId: [String]? = nil, filterIsrc: [String]? = nil, filterOwnersId: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksGetWithRequestBuilder(pageCursor: pageCursor, sort: sort?.compactMap { $0.toTracksAPIEnum() }, countryCode: countryCode, include: include, filterId: filterId, filterIsrc: filterIsrc, filterOwnersId: filterOwnersId, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Delete single track.
     
     - returns: MutationResponseDocument
     */
	public static func tracksIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
     Get single track.
     
     - returns: TracksSingleResourceDataDocument
     */
	public static func tracksIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Update single track.
     
     - returns: MutationResponseDocument
     */
	public static func tracksIdPatch(id: String, idempotencyKey: String? = nil, tracksUpdateOperationPayload: TracksUpdateOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, tracksUpdateOperationPayload: tracksUpdateOperationPayload)
		}
	}


	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: TracksAlbumsMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsAlbumsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksAlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Update albums relationship (\&quot;to-many\&quot;).
     
     - returns: MutationResponseDocument
     */
	public static func tracksIdRelationshipsAlbumsPatch(id: String, idempotencyKey: String? = nil, tracksAlbumsRelationshipUpdateOperationPayload: TracksAlbumsRelationshipUpdateOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsAlbumsPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, tracksAlbumsRelationshipUpdateOperationPayload: tracksAlbumsRelationshipUpdateOperationPayload)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: TracksArtistsMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsArtistsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsArtistsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get credits relationship (\&quot;to-many\&quot;).
     
     - returns: TracksCreditsMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsCreditsGet(id: String, pageCursor: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksCreditsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsCreditsGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get download relationship (\&quot;to-one\&quot;).
     
     - returns: TracksDownloadSingleRelationshipDataDocument
     */
	public static func tracksIdRelationshipsDownloadGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksDownloadSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsDownloadGetWithRequestBuilder(id: id, include: include, shareCode: shareCode)
		}
	}


	/**
     Get genres relationship (\&quot;to-many\&quot;).
     
     - returns: TracksGenresMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsGenresGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksGenresMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsGenresGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get lyrics relationship (\&quot;to-many\&quot;).
     
     - returns: TracksLyricsMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsLyricsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksLyricsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsLyricsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get metadataStatus relationship (\&quot;to-one\&quot;).
     
     - returns: TracksMetadataStatusSingleRelationshipDataDocument
     */
	public static func tracksIdRelationshipsMetadataStatusGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksMetadataStatusSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsMetadataStatusGetWithRequestBuilder(id: id, include: include, shareCode: shareCode)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: TracksOwnersMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsOwnersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsOwnersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get priceConfig relationship (\&quot;to-one\&quot;).
     
     - returns: TracksPriceConfigSingleRelationshipDataDocument
     */
	public static func tracksIdRelationshipsPriceConfigGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksPriceConfigSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsPriceConfigGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, shareCode: shareCode)
		}
	}


	/**
     Get providers relationship (\&quot;to-many\&quot;).
     
     - returns: TracksProvidersMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsProvidersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, shareCode: String? = nil) async throws -> TracksProvidersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsProvidersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, shareCode: shareCode)
		}
	}


	/**
     Get radio relationship (\&quot;to-many\&quot;).
     
     - returns: TracksRadioMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsRadioGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksRadioMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsRadioGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get replacement relationship (\&quot;to-one\&quot;).
     
     - returns: TracksReplacementSingleRelationshipDataDocument
     */
	public static func tracksIdRelationshipsReplacementGet(id: String, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksReplacementSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsReplacementGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get shares relationship (\&quot;to-many\&quot;).
     
     - returns: TracksSharesMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsSharesGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksSharesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsSharesGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get similarTracks relationship (\&quot;to-many\&quot;).
     
     - returns: TracksSimilarTracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsSimilarTracksGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksSimilarTracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsSimilarTracksGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get sourceFile relationship (\&quot;to-one\&quot;).
     
     - returns: TracksSourceFileSingleRelationshipDataDocument
     */
	public static func tracksIdRelationshipsSourceFileGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksSourceFileSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsSourceFileGetWithRequestBuilder(id: id, include: include, shareCode: shareCode)
		}
	}


	/**
     Get suggestedTracks relationship (\&quot;to-many\&quot;).
     
     - returns: TracksSuggestedTracksMultiRelationshipDataDocument
     */
	public static func tracksIdRelationshipsSuggestedTracksGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil, shareCode: String? = nil) async throws -> TracksSuggestedTracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsSuggestedTracksGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include, replaceMedia: replaceMedia, shareCode: shareCode)
		}
	}


	/**
     Get trackStatistics relationship (\&quot;to-one\&quot;).
     
     - returns: TracksTrackStatisticsSingleRelationshipDataDocument
     */
	public static func tracksIdRelationshipsTrackStatisticsGet(id: String, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksTrackStatisticsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsTrackStatisticsGetWithRequestBuilder(id: id, include: include, shareCode: shareCode)
		}
	}


	/**
     Get usageRules relationship (\&quot;to-one\&quot;).
     
     - returns: TracksUsageRulesSingleRelationshipDataDocument
     */
	public static func tracksIdRelationshipsUsageRulesGet(id: String, countryCode: String? = nil, include: [String]? = nil, shareCode: String? = nil) async throws -> TracksUsageRulesSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksIdRelationshipsUsageRulesGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, shareCode: shareCode)
		}
	}


	/**
     Create single track.
     
     - returns: TracksCreateSingleResourceDataDocument
     */
	public static func tracksPost(idempotencyKey: String? = nil, tracksCreateOperationPayload: TracksCreateOperationPayload? = nil) async throws -> TracksCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TracksAPI.tracksPostWithRequestBuilder(idempotencyKey: idempotencyKey, tracksCreateOperationPayload: tracksCreateOperationPayload)
		}
	}
}
