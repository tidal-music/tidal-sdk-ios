import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `AlbumStatisticsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await AlbumStatisticsAPITidal.getResource()
/// ```
public enum AlbumStatisticsAPITidal {


	/**
     Get multiple albumStatistics.
     
     - returns: AlbumStatisticsMultiResourceDataDocument
     */
	public static func albumStatisticsGet(include: [String]? = nil, filterId: [String]? = nil) async throws -> AlbumStatisticsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			AlbumStatisticsAPI.albumStatisticsGetWithRequestBuilder(include: include, filterId: filterId)
		}
	}


	/**
     Get single albumStatistic.
     
     - returns: AlbumStatisticsSingleResourceDataDocument
     */
	public static func albumStatisticsIdGet(id: String, include: [String]? = nil) async throws -> AlbumStatisticsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			AlbumStatisticsAPI.albumStatisticsIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumStatisticsMultiRelationshipDataDocument
     */
	public static func albumStatisticsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumStatisticsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumStatisticsAPI.albumStatisticsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
