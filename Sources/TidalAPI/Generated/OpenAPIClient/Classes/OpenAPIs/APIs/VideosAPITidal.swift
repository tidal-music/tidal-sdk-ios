import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `VideosAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await VideosAPITidal.getResource()
/// ```
public enum VideosAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_videosGet: String, CaseIterable {
		case albums = "albums"
		case artists = "artists"
		case credits = "credits"
		case providers = "providers"
		case replacement = "replacement"
		case similarvideos = "similarVideos"
		case suggestedvideos = "suggestedVideos"
		case thumbnailart = "thumbnailArt"
		case usagerules = "usageRules"

		func toVideosAPIEnum() -> VideosAPI.IncludeLinkage_videosGet {
			switch self {
			case .albums: return .albums
			case .artists: return .artists
			case .credits: return .credits
			case .providers: return .providers
			case .replacement: return .replacement
			case .similarvideos: return .similarvideos
			case .suggestedvideos: return .suggestedvideos
			case .thumbnailart: return .thumbnailart
			case .usagerules: return .usagerules
			}
		}
	}

	/**
     Get multiple videos.
     
     - returns: VideosMultiResourceDataDocument
     */
	public static func videosGet(countryCode: String? = nil, filterId: [String]? = nil, filterIsrc: [String]? = nil, include: [String]? = nil, includeLinkage: [VideosAPITidal.IncludeLinkage_videosGet]? = nil, replaceMedia: String? = nil) async throws -> VideosMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosGetWithRequestBuilder(countryCode: countryCode, filterId: filterId, filterIsrc: filterIsrc, include: include, includeLinkage: includeLinkage?.compactMap { $0.toVideosAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_videosIdGet: String, CaseIterable {
		case albums = "albums"
		case artists = "artists"
		case credits = "credits"
		case providers = "providers"
		case replacement = "replacement"
		case similarvideos = "similarVideos"
		case suggestedvideos = "suggestedVideos"
		case thumbnailart = "thumbnailArt"
		case usagerules = "usageRules"

		func toVideosAPIEnum() -> VideosAPI.IncludeLinkage_videosIdGet {
			switch self {
			case .albums: return .albums
			case .artists: return .artists
			case .credits: return .credits
			case .providers: return .providers
			case .replacement: return .replacement
			case .similarvideos: return .similarvideos
			case .suggestedvideos: return .suggestedvideos
			case .thumbnailart: return .thumbnailart
			case .usagerules: return .usagerules
			}
		}
	}

	/**
     Get single video.
     
     - returns: VideosSingleResourceDataDocument
     */
	public static func videosIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [VideosAPITidal.IncludeLinkage_videosIdGet]? = nil, replaceMedia: String? = nil) async throws -> VideosSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toVideosAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: VideosAlbumsMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsAlbumsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> VideosAlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: VideosArtistsMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsArtistsGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> VideosArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Get credits relationship (\&quot;to-many\&quot;).
     
     - returns: VideosCreditsMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsCreditsGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> VideosCreditsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsCreditsGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Get providers relationship (\&quot;to-many\&quot;).
     
     - returns: VideosProvidersMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsProvidersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> VideosProvidersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsProvidersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get replacement relationship (\&quot;to-one\&quot;).
     
     - returns: VideosReplacementSingleRelationshipDataDocument
     */
	public static func videosIdRelationshipsReplacementGet(id: String, countryCode: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> VideosReplacementSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsReplacementGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get similarVideos relationship (\&quot;to-many\&quot;).
     
     - returns: VideosSimilarVideosMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsSimilarVideosGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> VideosSimilarVideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsSimilarVideosGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Get suggestedVideos relationship (\&quot;to-many\&quot;).
     
     - returns: VideosSuggestedVideosMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsSuggestedVideosGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> VideosSuggestedVideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsSuggestedVideosGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Get thumbnailArt relationship (\&quot;to-many\&quot;).
     
     - returns: VideosThumbnailArtMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsThumbnailArtGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> VideosThumbnailArtMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsThumbnailArtGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get usageRules relationship (\&quot;to-one\&quot;).
     
     - returns: VideosUsageRulesSingleRelationshipDataDocument
     */
	public static func videosIdRelationshipsUsageRulesGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> VideosUsageRulesSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsUsageRulesGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}
}
