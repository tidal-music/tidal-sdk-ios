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
     Relationship: albums
     
     - returns: VideosMultiDataRelationshipDocument
     */
	public static func getVideoAlbumsRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> VideosMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.getVideoAlbumsRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Relationship: artists
     
     - returns: VideosMultiDataRelationshipDocument
     */
	public static func getVideoArtistsRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> VideosMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.getVideoArtistsRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get single video
     
     - returns: VideosSingleDataDocument
     */
	public static func getVideoById(id: String, countryCode: String, include: [String]? = nil) async throws -> VideosSingleDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.getVideoByIdWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Relationship: providers
     
     - returns: VideosMultiDataRelationshipDocument
     */
	public static func getVideoProvidersRelationship(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> VideosMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.getVideoProvidersRelationshipWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get multiple videos
     
     - returns: VideosMultiDataDocument
     */
	public static func getVideosByFilters(countryCode: String, include: [String]? = nil, filterId: [String]? = nil, filterIsrc: [String]? = nil) async throws -> VideosMultiDataDocument {
		return try await RequestHelper.createRequest {
			VideosAPI.getVideosByFiltersWithRequestBuilder(countryCode: countryCode, include: include, filterId: filterId, filterIsrc: filterIsrc)
		}
	}
}
