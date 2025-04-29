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
     
     - returns: VideosMultiDataDocument
     */
	public static func videosGet(countryCode: String, include: [String]? = nil, filterIsrc: [String]? = nil, filterId: [String]? = nil) async throws -> VideosMultiDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosGetWithRequestBuilder(countryCode: countryCode, include: include, filterIsrc: filterIsrc, filterId: filterId)
		}
	}


	/**
     Get single video.
     
     - returns: VideosSingleDataDocument
     */
	public static func videosIdGet(id: String, countryCode: String, include: [String]? = nil) async throws -> VideosSingleDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: VideosMultiDataRelationshipDocument
     */
	public static func videosIdRelationshipsAlbumsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> VideosMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: VideosMultiDataRelationshipDocument
     */
	public static func videosIdRelationshipsArtistsGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> VideosMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get providers relationship (\&quot;to-many\&quot;).
     
     - returns: VideosMultiDataRelationshipDocument
     */
	public static func videosIdRelationshipsProvidersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> VideosMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsProvidersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get thumbnailArt relationship (\&quot;to-many\&quot;).
     
     - returns: VideosMultiDataRelationshipDocument
     */
	public static func videosIdRelationshipsThumbnailArtGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> VideosMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.videosIdRelationshipsThumbnailArtGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}
}
