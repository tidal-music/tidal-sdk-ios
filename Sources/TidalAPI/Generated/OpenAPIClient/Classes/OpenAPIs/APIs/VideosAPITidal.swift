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
     Get multiple videos.
     
     - returns: VideosMultiResourceDataDocument
     */
	public static func videosGet(countryCode: String? = nil, include: [String]? = nil, filterId: [String]? = nil, filterIsrc: [String]? = nil) async throws -> VideosMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosGetWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId, filterIsrc: filterIsrc)
		}
	}


	/**
     Get single video.
     
     - returns: VideosSingleResourceDataDocument
     */
	public static func videosIdGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> VideosSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: VideosMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsAlbumsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> VideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsAlbumsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: VideosMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsArtistsGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> VideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsArtistsGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Get credits relationship (\&quot;to-many\&quot;).
     
     - returns: VideosMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsCreditsGet(id: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> VideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsCreditsGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Get providers relationship (\&quot;to-many\&quot;).
     
     - returns: VideosMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsProvidersGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> VideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsProvidersGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Get replacement relationship (\&quot;to-one\&quot;).
     
     - returns: VideosSingleRelationshipDataDocument
     */
	public static func videosIdRelationshipsReplacementGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> VideosSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsReplacementGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Get similarVideos relationship (\&quot;to-many\&quot;).
     
     - returns: VideosMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsSimilarVideosGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> VideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsSimilarVideosGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Get suggestedVideos relationship (\&quot;to-many\&quot;).
     
     - returns: VideosMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsSuggestedVideosGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> VideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsSuggestedVideosGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Get thumbnailArt relationship (\&quot;to-many\&quot;).
     
     - returns: VideosMultiRelationshipDataDocument
     */
	public static func videosIdRelationshipsThumbnailArtGet(id: String, pageCursor: String? = nil, countryCode: String? = nil, include: [String]? = nil) async throws -> VideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsThumbnailArtGetWithRequestBuilder(id: id, pageCursor: pageCursor, countryCode: countryCode, include: include)
		}
	}


	/**
     Get usageRules relationship (\&quot;to-one\&quot;).
     
     - returns: VideosSingleRelationshipDataDocument
     */
	public static func videosIdRelationshipsUsageRulesGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> VideosSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsUsageRulesGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}
}
